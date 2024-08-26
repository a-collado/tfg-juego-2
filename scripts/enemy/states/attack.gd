extends EnemyState
class_name Attack

signal reset_prediction_area

var has_attacked := false
var last_attack: int = 0
var time_to_last_attack: int = 1
var idle_time: int = 0
var time_to_idle_time: int = 100

func enter():
	print_rich("Log: [color=#ff2c2c][b]Attack state entered[/b][/color]")
	_setup()
	enemy.movement = true
	idle_time = 0
	last_attack = 1
	reset_prediction_area.emit()

func exit():
	pass

func physics_update():
	agent.target_position = ball_future.transform.origin
	#print_rich("Log: [color=#008000]Attack:[b] update[/b][/color]")

	if enemy.movement:
		idle_time = 0
		#print_rich("Log: [color=#008000]Attack:[b] movement[/b][/color]")

	if ball_future.transform.origin.z > 0 or idle_time > time_to_idle_time:
		Transitioned.emit(self, "Defend")

	if animation_manager.is_hitting():
		has_attacked = true
		#print_rich("Log: [color=#008000]Attack:[b] has_attacked[/b][/color]")

	if not animation_manager.is_hitting() and has_attacked:
		#print_rich("Log: [color=#008000]Attack:[b] has_attacked & movement[/b][/color]")
		has_attacked = false
		enemy.movement = true

	if not enemy.movement:
		idle_time += 1
		#print_rich("Log: [color=#008000]Attack:[b] not movement[/b][/color]")

	last_attack += 1

func _on_hit_prediction_area_area_entered(_area:Area3D) -> void:
	if not active:
		return

	print("--------------------------------------------------------------------------------------------------------")
	var debug_format_string := "Log: [color=#008000]Attack:[b] has_attacked = [color=#ff2c2c]{atk}[/color] | enemy.movement = [color=#ff2c2c]{mv} [/color]| last attack = [color=#ff2c2c]{la}[/color][/b] | [b]charge_level = [color=#ff2c2c]{al}[/color][/b][/color]"
	var debug_string := debug_format_string.format({"atk": has_attacked, "mv": has_attacked, "la": last_attack, "al": charge_bar.charge_level })
	print_rich(debug_string)
	print("--------------------------------------------------------------------------------------------------------")

	if charge_bar.charge_level < 1:
		Transitioned.emit(self, "Charge")

	if not has_attacked and enemy.movement and last_attack >= time_to_last_attack and charge_bar.charge_level > 0:
		enemy.movement = false
		last_attack = 0
		print_rich("Log: [color=#008000]Attack:[b] prediction_area [/b][/color]")
