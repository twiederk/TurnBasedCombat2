class_name PlayerBattler
extends Battler


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

