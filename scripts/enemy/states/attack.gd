extends EnemyState
class_name Attack

func enter():
	LogDuck.d("[color=#ff2c2c][b]Attack state entered[/b][/color]")
	_setup()
	enemy.movement = false

func exit():
	pass

func update():
	pass

func physics_update():
	#Transitioned.emit(self, "Defend")
	pass

