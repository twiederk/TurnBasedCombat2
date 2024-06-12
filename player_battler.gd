class_name PlayerBattler
extends Node2D

@export var stats_resource: BattlerStats

var current_hp: int

signal dead(this_battler: Node2D)
signal turn_ended

@onready var health_bar = $HealthBar
@onready var turn_indicator = $TurnIndicator

func _ready():
	current_hp = stats_resource.max_hp
	_update_health_bar()
	
func _update_health_bar() -> void:
	health_bar.max_value = stats_resource.max_hp
	health_bar.value = current_hp

func start_turn() -> void:
	print("PlayerBattler.start_turn")
	turn_indicator.show()
	

func stop_turn() -> void:
	print("PlayerBattler.stop_turn")
	turn_indicator.hide()
	# animation_player.play("RESET")
	# hit_fx_animaiton.play("RESET")

func start_attacking(enemy_target: Node2D) -> void:
	print("PlayerBattler.start_attacking")	
	enemy_target.be_damaged(_get_attack_damage())
	turn_ended.emit()
	
	
func _get_attack_damage() -> int:
	return randi_range(stats_resource.min_damage, stats_resource.max_damage)
	

func be_damaged(amount: int) -> void:
	print("PlayerBattler.be_damaged")
	current_hp -= amount
	_update_health_bar()
	if current_hp <= 0:
		current_hp = 0
		dead.emit(self)
		queue_free()

