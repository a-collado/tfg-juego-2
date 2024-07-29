extends EnemyState
class_name Idle


func enter():
	print_rich("Log: [color=#ff2c2c][b]Idle state entered[/b][/color]")
		
	## Esperamos a que haya procesado el primer frame para
	## poder hacer el setup sin que sea null y de error
	await get_tree().process_frame
	_setup()
	enemy.movement = false

func exit():
	pass

func update():
	pass

func physics_update():
	Transitioned.emit(self, "Defend")
