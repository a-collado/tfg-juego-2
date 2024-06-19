extends State
class_name Idle

func enter():
	LogDuck.d("[color=#ff2c2c][b]Idle state entered[/b][/color]")

func exit():
	pass

func update():
	pass

func physics_update():
	Transitioned.emit(self, "Defend")
	pass
