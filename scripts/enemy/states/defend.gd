extends EnemyState
class_name Defend

func enter():
	LogDuck.d("[color=#ff2c2c][b]Defend state entered[/b][/color]")
	_setup()
	enemy.movement = true

func exit():
	enemy.movement = false

func physics_update():
	#var direction = ball.transform.origin - enemy.transform.origin
	#navigator.setNavInput(direction)
	agent.target_position = ball_future.transform.origin

## Quizas esto habria que moverlo a otro lado
func _on_hit_prediction_area_area_entered(_area:Area3D) -> void:
	if active and hit_manager.charge_bar.charge_level > 0:
		Transitioned.emit(self, "Attack")

