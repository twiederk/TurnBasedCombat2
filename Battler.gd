class_name Battler
extends Node

signal dead(this_battler: Node2D)
signal turn_ended

@export var stats_resource: BattlerStats

var current_hp: int

@onready var health_bar = $HealthBar
@onready var turn_indicator = $TurnIndicator


func _ready():
	current_hp = stats_resource.max_hp
	_update_health_bar()


func _update_health_bar() -> void:
	health_bar.max_value = stats_resource.max_hp
	health_bar.value = current_hp


func _get_attack_damage() -> int:
	return randi_range(stats_resource.min_damage, stats_resource.max_damage)
	

func be_damaged(amount: int) -> void:
	print("Battler.be_damaged")
	current_hp -= amount
	_update_health_bar()
	if current_hp <= 0:
		current_hp = 0
		dead.emit(self)
		queue_free()
