class_name EnemyBattler
extends Battler

@onready var select_target_button = $SelectTargetButton

signal be_selected(this_target: Node2D)
signal deal_damage(damage: int)

func _ready() -> void:
	super._ready()
	select_target_button.hide()
	select_target_button.pressed.connect(_on_select_button_pressed)


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


