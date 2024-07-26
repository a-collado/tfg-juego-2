extends EnemyState
class_name Defend

func enter():
	LogDuck.d("[color=#ff2c2c][b]Defend state entered[/b][/color]")
	_setup()

func exit():
	pass

func update():
	pass

func physics_update():
	#var direction = ball.transform.origin - enemy.transform.origin
	#navigator.setNavInput(direction)
	agent.target_position = ball_future.transform.origin

## Quizas esto habria que moverlo a otro lado
func _on_hit_prediction_area_area_entered(_area:Area3D) -> void:
	if active:	
		enemy.animation_manager.hit(1)

