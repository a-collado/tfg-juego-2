extends Node

@export_range(1,10) var points_to_win: int = 3
@export_file("*.tscn") var start_scren_scene_path: String = "res://scenes/startScreen.tscn"

@onready var UI_loading = $"../UI/Loading"
@onready var UI_pause_menu = $"../UI/PauseMenu"
@onready var game = $".."
var is_multiplayer = false

# Called when the node enters the scene tree for the first time.
func _ready():
	UI_pause_menu.visible = false
	if game is MultiplayerGame:
		is_multiplayer = true
		game.connect("end_loading", end_load_screen)
	else:
		end_load_screen()

func end_load_screen():
	UI_loading.visible = false

func _on_pause_pressed():
	if not is_multiplayer:
		get_tree().paused = true
	UI_pause_menu.visible = true

func _on_resume_pressed():
	if not is_multiplayer:
		get_tree().paused = false
	UI_pause_menu.visible = false

func _on_exit_pressed():
	if not is_multiplayer:
		get_tree().paused = false
	get_tree().change_scene_to_file(start_scren_scene_path)
