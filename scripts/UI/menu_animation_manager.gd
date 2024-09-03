extends Node

signal load_singleplayer

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
@onready var lobby_menu_single: Control = $"/root/StartScreen/Lobby Menu/Single"
@onready var lobby_menu_multi: Control = $"/root/StartScreen/Lobby Menu/Multi"
@onready var settings: Control = $"/root/StartScreen/Settings"

## Nodos de singleplayer
@onready var singleplayer_nodes: Control = $"/root/StartScreen/Singleplayer"
@onready var singleplayer_nodes_difficulty: Control = $"/root/StartScreen/Singleplayer/Difficulty"
@onready var singleplayer_nodes_goals: Control = $"/root/StartScreen/Singleplayer/Goals"
@onready var singleplayer_nodes_back: Control = $"/root/StartScreen/Singleplayer/Back"

@onready var singleplayer_difficulty_low_button: Button = $"/root/StartScreen/Singleplayer/Difficulty/Options/Low"
@onready var singleplayer_difficulty_mid_button: Button = $"/root/StartScreen/Singleplayer/Difficulty/Options/Mid"
@onready var singleplayer_difficulty_top_button: Button = $"/root/StartScreen/Singleplayer/Difficulty/Options/Top"
@onready var singleplayer_difficulty_low_background: Sprite2D = $"/root/StartScreen/Singleplayer/Difficulty/Options/Background Low"
@onready var singleplayer_difficulty_mid_background: Sprite2D = $"/root/StartScreen/Singleplayer/Difficulty/Options/Background Mid"
@onready var singleplayer_difficulty_top_background: Sprite2D = $"/root/StartScreen/Singleplayer/Difficulty/Options/Background Top"

@export var move: bool = true

var started: bool = false
var singleplayer: bool = false

func _ready():
	started = Variables.screen_touched

	if started:
		robot.visible = false
		start_screen_bottom.position.x = 580
		lobby_menu_single.position.x = 600
		lobby_menu_multi.position.x = 600

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
	tween.tween_property(start_screen_bottom, "position:x", 580, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_single, "position:x", 600, 1.0).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_multi, "position:x", 600, 1.0).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
	started = true
	Variables.screen_touched = true

func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().quit()
		#get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

func _on_start_screen_start_singleplayer_mode() -> void:
	if not singleplayer:
		singleplayer = true
		singleplayer_nodes_difficulty.position.x = 0
		singleplayer_nodes_goals.position.x = 1235 
		singleplayer_nodes_back.position.x = 0

		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(lobby_menu_single, "position:y", 8, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(lobby_menu_multi, "position:y", 1300, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(singleplayer_nodes_goals, "position:x", 650, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(singleplayer_nodes_difficulty, "position:x", 650, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(singleplayer_nodes_back, "position:x", 650, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(settings, "position:y", 1300, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	else:
		load_singleplayer.emit()

func _on_back_pressed() -> void:
	singleplayer = false
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(lobby_menu_single, "position:y", 284, 1.0).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_multi, "position:y", 677, 1.0).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(singleplayer_nodes_goals, "position:x", 1235, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(singleplayer_nodes_difficulty, "position:x", 0, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(singleplayer_nodes_back, "position:x", -5, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(settings, "position:y", 1159, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)

