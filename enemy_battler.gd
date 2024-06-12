class_name EnemyBattler
extends Node2D

@export var stats_resource: BattlerStats

@onready var health_bar = $HealthBar
@onready var select_target_button = $SelectTargetButton
@onready var turn_indicator = $TurnIndicator

var current_hp: int

signal be_selected(this_target: Node2D)
signal dead(this_enemy: Node2D)
signal deal_damage(damage: int)

func _ready() -> void:
	select_target_button.hide()
	
	current_hp = stats_resource.max_hp
	
	select_target_button.pressed.connect(_on_select_button_pressed)
	
	_update_health_bar()
	
func _update_health_bar() -> void:
	health_bar.max_value = stats_resource.max_hp
	health_bar.value = current_hp


func start_turn() -> void:
	print("EnemyBattler.start_turn")
	deal_damage.emit(_get_attack_damage())
	

func stop_turn() -> void:
	print("EnemyBattler.stop_turn")

	
func show_select_button() -> void:
	select_target_button.show()
	

func hide_select_button() -> void:
	select_target_button.hide()
	

func _on_select_button_pressed() -> void:
	be_selected.emit(self)
	
	
func _get_attack_damage() -> int:
	return randi_range(stats_resource.min_damage, stats_resource.max_damage)


func be_damaged(amount: int) -> void:
	print("EnemyBattler.be_damaged")
	current_hp -= amount
	_update_health_bar()
	if current_hp <= 0:
		current_hp = 0
		dead.emit(self)
		queue_free()
	


