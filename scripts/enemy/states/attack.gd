extends EnemyState
class_name Attack

var has_attacked := false

func enter():
	LogDuck.d("[color=#ff2c2c][b]Attack state entered[/b][/color]")
	_setup()
	enemy.movement = false

func exit():
	pass

func update():
	pass

func physics_update():
	if animation_manager.is_hitting():
		has_attacked = true

	if not animation_manager.is_hitting() and has_attacked:
		has_attacked = not has_attacked
		Transitioned.emit(self, "Defend")

