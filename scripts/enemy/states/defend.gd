extends EnemyState
class_name Defend

var follow: Node3D

func enter():
	LogDuck.d("[color=#ff2c2c][b]Defend state entered[/b][/color]")
	_setup()
	follow = enemy.enemy_ia_follow.defend_state_follow
	enemy.movement = true

func exit():
	enemy.movement = false

func physics_update():
	#var direction = ball.transform.origin - enemy.transform.origin
	#navigator.setNavInput(direction)
	agent.target_position = follow.transform.origin

func _on_hit_prediction_area_area_entered(_area:Area3D) -> void:
	if active and hit_manager.charge_bar.charge_level > 0:
		Transitioned.emit(self, "Attack")
