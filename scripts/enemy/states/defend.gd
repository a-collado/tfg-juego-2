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
	if ball.transform.origin.z < 0:
		Transitioned.emit(self, "Attack")

	agent.target_position = follow.transform.origin
	
	if agent.distance_to_target() < 0.1:
		enemy.movement = false
	else:
		enemy.movement = true
