extends EnemyState
class_name Attack

var has_attacked := false
var last_attack: int = 0
var time_to_last_attack: int = 30
var idle_time: int = 0
var time_to_idle_time: int = 100

func enter():
	print_rich("Log: [color=#ff2c2c][b]Attack state entered[/b][/color]")
	_setup()
	enemy.movement = true
	idle_time = 0
	last_attack = 0

func exit():
	pass

func physics_update():
	agent.target_position = ball_future.transform.origin

	if enemy.movement:
		idle_time = 0

	if ball_future.transform.origin.z > 0 or idle_time > time_to_idle_time:
		Transitioned.emit(self, "Defend")

	if animation_manager.is_hitting():
		has_attacked = true
		print("Has attacked: true")

	if not animation_manager.is_hitting() and has_attacked:
		print("Has attacked and has hitted: true")
		print("Has attacked: false")
		has_attacked = false
		enemy.movement = true

	if not enemy.movement:
		idle_time += 1

	last_attack += 1

func _on_hit_prediction_area_area_entered(_area:Area3D) -> void:
	if not has_attacked and enemy.movement and last_attack > time_to_last_attack:
		enemy.movement = false
		last_attack = 0
		print("Prediciont area: true")
