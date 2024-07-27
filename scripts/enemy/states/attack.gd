extends EnemyState
class_name Attack

var has_attacked := false

func enter():
	LogDuck.d("[color=#ff2c2c][b]Attack state entered[/b][/color]")
	_setup()
	enemy.movement = true

func exit():
	pass

func physics_update():
	agent.target_position = ball_future.transform.origin

	if ball_future.transform.origin.z > 0:
		Transitioned.emit(self, "Defend")

	if animation_manager.is_hitting():
		has_attacked = true

	if not animation_manager.is_hitting() and has_attacked:
		has_attacked = false
		enemy.movement = true

func _on_hit_prediction_area_area_entered(_area:Area3D) -> void:
	if not has_attacked:
		enemy.movement = false
