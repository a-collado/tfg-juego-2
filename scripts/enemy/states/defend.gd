extends State
class_name Defend

@onready var enemy: Enemy = get_parent().get_parent()
@onready var team: Team = enemy.team

func enter():
	LogDuck.d("[color=#ff2c2c][b]Defend state entered[/b][/color]")
	LogDuck.d(team)

func exit():
	pass

func update():
	pass

func physics_update():
	pass
