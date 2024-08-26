extends EnemyState
class_name Charge

func enter():
	print_rich("Log: [color=#ff2c2c][b]Charge state entered[/b][/color]")
	_setup()
	enemy.movement = true

func physics_update():
	if charge_bar.charge_level > 0:
		Transitioned.emit(self, "Attack")
