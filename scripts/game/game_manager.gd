extends Node

@export_file("*.tscn") var start_scren_scene_path: String = "res://scenes/startScreen.tscn"

@onready var UI_loading = $"../UI/Loading"
@onready var UI_pause_menu_resume = $"../UI/Resume"
@onready var UI_pause_menu_settings = $"../UI/Settings"
@onready var UI_pause_menu_quit = $"../UI/Quit"
@onready var UI_settings = $"../UI/Settings Screen"

@onready var game = $".."

@onready var score_manager = $"Score Manager"
@onready var ball_spawn_A: Marker3D = $"../Team A/Ball Spawn A"
@onready var ball_spawn_B: Marker3D = $"../Team B/Ball Spawn B"
@onready var ball: Ball = %Ball

var is_multiplayer = false

func _ready():
	Lobby.connect("player_disconnected", _on_player_disconnected)
	score_manager.connect("reset_ball", _reset_ball)
	score_manager.connect("exit", _on_exit_pressed)

	_change_menu_visibility(false)
	score_manager.score_to_win = Variables.goals_to_win
	if game is MultiplayerGame:
		is_multiplayer = true
		game.connect("end_loading", end_load_screen)
	else:
		end_load_screen()

func end_load_screen():
	UI_loading.visible = false

func _on_pause_pressed():
	if not UI_pause_menu_resume.visible:
		if not is_multiplayer:
			get_tree().paused = true
		_change_menu_visibility(true) 
	else:
		_on_resume_pressed()

func _on_resume_pressed():
	if not is_multiplayer:
		get_tree().paused = false
	_change_menu_visibility(false)

func _on_exit_pressed():
	if is_multiplayer:
		Lobby.remove_multiplayer_peer()
	_exit_to_menu()

func _on_settings_pressed() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(UI_settings, "position:x", 0, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)

func _on_player_disconnected(_id):
	if is_multiplayer:
		Lobby.remove_multiplayer_peer()
	_exit_to_menu()

func _exit_to_menu():
	if get_tree().paused:
		get_tree().paused = false
	get_tree().change_scene_to_file(start_scren_scene_path)

func _reset_ball(spawn: String):
	var position: Vector3
	if spawn == "A":
		position = ball_spawn_A.position
	else:
		position = ball_spawn_B.position

	if is_multiplayer:
		ball.reset.rpc(position)
	else:
		ball.reset(position)

func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if UI_pause_menu_resume.visible:
			_on_resume_pressed()
		else:
			_on_pause_pressed()

func _change_menu_visibility(visibility: bool) -> void:
	UI_pause_menu_resume.visible = visibility
	UI_pause_menu_settings.visible = visibility
	UI_pause_menu_quit.visible = visibility


func _on_settings_back_pressed() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(UI_settings, "position:x", -600, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)

