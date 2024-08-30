extends Node

## Nodos hijos
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var timer: Timer = $Timer
@onready var animation_timer: Timer = $animation_timer

## Nodos 3D
@onready var robot: Node3D = $"/root/StartScreen/3D/root"

## Nodos de control
@onready var start_screen: Control = $/root/StartScreen/Start
@onready var start_button: Button = $/root/StartScreen/Start/Start
@onready var start_screen_bottom: Control = $/root/StartScreen/Start/Fondo
@onready var lobby_menu: Control = $"/root/StartScreen/Lobby Menu"

@export var move: bool = true

func _process(delta: float) -> void:
	if not move:
		return
	robot.global_position.x += 1 * delta
	if (robot.global_position.x > 1.60):
		robot.global_position.x = -1.60

func bat():
	animation_tree.set("parameters/Bateo/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func reset_timer():
	timer.wait_time = randi_range(1,5)
	timer.start()

func _on_timer_timeout() -> void:
	bat()

func _on_start_button_down():
	start_button.disabled = true
	animation_tree.set("parameters/Sumergir/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func hide_character():
	robot.visible = false
	move = false
	_hide_main_screen()

func _hide_main_screen():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(start_screen_bottom, "position:x", 580, 1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(lobby_menu, "position:x", 0, 2.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
