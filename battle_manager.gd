class_name BattleManager
extends Node

const PlayerBattlerScene = preload("res://player_battler.tscn")

var all_battlers = []
var player_battlers = []
var enemy_battlers = []

var current_turn: Node2D
var current_turn_index: int

@onready var turn_action_buttons = $CanvasLayer/TurnActionButtons
@onready var skip_turn_button = $CanvasLayer/TurnActionButtons/SkipTurnButton
@onready var attack_button = $CanvasLayer/TurnActionButtons/AttackButton
@onready var battle_end_panel = $CanvasLayer/BattleEndPanel
@onready var battle_end_text = $CanvasLayer/BattleEndPanel/BattleEndText

func _ready():
	turn_action_buttons.hide()
	battle_end_panel.hide()

	var player1 = PlayerBattlerScene.instantiate()
	player1.stats_resource = create_battler_stats(400, 100, 200, 50)
	player1.position = Vector2(100, 100)
	add_child(player1)
	player1.set_texture(load("res://Battlers/World01_007_Pirate.png"))

	var player2 = PlayerBattlerScene.instantiate()
	player2.stats_resource = create_battler_stats(400, 100, 200, 50)
	player2.position = Vector2(100, 300)
	add_child(player2)
	player2.set_texture(load("res://Battlers/World01_005_Shello.png"))

	var player3 = PlayerBattlerScene.instantiate()
	player3.stats_resource = create_battler_stats(400, 100, 200, 50)
	player3.position = Vector2(100, 500)
	add_child(player3)
	player3.set_texture(load("res://Battlers/World04_003_ Outlaw.png"))

	player_battlers = get_tree().get_nodes_in_group("PlayerBattler")
	enemy_battlers = get_tree().get_nodes_in_group("EnemyBattler")
	all_battlers.append_array(player_battlers)
	all_battlers.append_array(enemy_battlers)

	all_battlers.sort_custom(_sort_turn_order_ascending)

	skip_turn_button.pressed.connect(_next_turn)
	attack_button.pressed.connect(_show_target_buttons)

	for p in player_battlers:
		p.turn_ended.connect(_next_turn)
		p.dead.connect(_on_player_dead)

	for e in enemy_battlers:
		e.be_selected.connect(_attack_selected_enemy)
		e.dead.connect(_on_enemy_dead)
		e.deal_damage.connect(_attack_random_player_battler)

	current_turn = all_battlers[current_turn_index]
	_update_turn()

func _sort_turn_order_ascending(battler_1, battler_2) -> bool:
	if battler_1.stats_resource.turn_speed < battler_2.stats_resource.turn_speed:
		return true
	return false


func _update_turn() -> void:
	if current_turn.stats_resource.type == BattlerStats.BattlerType.Player:
		turn_action_buttons.show()
	else: # enemy
		turn_action_buttons.hide()
	current_turn.start_turn()


func _next_turn() -> void:
	if turn_action_buttons.visible:
		turn_action_buttons.hide()
	current_turn.stop_turn()
	if _check_for_battle_end() == false:
		current_turn_index = (current_turn_index + 1) % all_battlers.size()
		current_turn = all_battlers[current_turn_index]
	_update_turn()


func _show_target_buttons() -> void:
	turn_action_buttons.hide()
	for e in enemy_battlers:
		e.show_select_button()


func _hide_target_buttons() -> void:
	for e in enemy_battlers:
		e.hide_select_button()


func _attack_selected_enemy(selected_enemy: Node2D) -> void:
	_hide_target_buttons()
	current_turn.start_attacking(selected_enemy)


func _attack_random_player_battler(damage: int) -> void:
	var rand = randi_range(0, player_battlers.size() - 1)
	player_battlers[rand].be_damaged(damage)
	_next_turn()


func _on_enemy_dead(dead_enemy: Node2D) -> void:
	enemy_battlers.erase(dead_enemy)
	all_battlers.erase(dead_enemy)


func _on_player_dead(dead_player: Node2D) -> void:
	player_battlers.erase(dead_player)
	all_battlers.erase(dead_player)


func _check_for_battle_end() -> bool:
	if enemy_battlers.is_empty():
		_show_battle_end_panel("Player won!")
		return true
	elif player_battlers.is_empty():
		_show_battle_end_panel("Player lost!")
		return true
	return false


func _show_battle_end_panel(message: String) -> void:
	battle_end_text.clear()
	battle_end_text.append_text("[center]%s" % [message])
	battle_end_panel.show()
	if turn_action_buttons.visible:
		turn_action_buttons.hide()


func create_battler_stats(max_hp: int, min_damage: int, max_damage: int, turn_speed: int) -> BattlerStats:
	var battlerStats = BattlerStats.new()
	battlerStats.type = BattlerStats.BattlerType.Player
	battlerStats.max_hp = max_hp
	battlerStats.min_damage = min_damage
	battlerStats.max_damage = max_damage
	battlerStats.turn_speed = turn_speed
	return battlerStats
