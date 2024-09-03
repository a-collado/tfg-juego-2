extends Control

signal start_singleplayer_mode

@export_file("*.tscn") var game_scene_path: String = "res://scenes/game-sp.tscn"
@export_file("*.tscn") var multi_scene_path: String = "res://scenes/lobby.tscn"
@onready var UI_loading = $Loading

var loading_status: int

func _ready():
	UI_loading.visible = false

func _on_multi_pressed() -> void:
	get_tree().change_scene_to_file(multi_scene_path)

func _on_single_pressed() -> void:
	start_singleplayer_mode.emit()

func _process(_delta: float) -> void:
	loading_status = ResourceLoader.load_threaded_get_status(game_scene_path)
	
	if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(game_scene_path))

func _on_animation_manager_load_singleplayer() -> void:
	UI_loading.visible = true
	ResourceLoader.load_threaded_request(game_scene_path)
