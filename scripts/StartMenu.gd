extends Control

@export_file("*.tscn") var game_scene_path: String = "res://scenes/game-sp.tscn"
@export_file("*.tscn") var multi_scene_path: String = "res://scenes/lobby.tscn"
@onready var UI_loading = $Loading

func _ready():
	UI_loading.visible = false

func _on_multiplayer_pressed() -> void:
	get_tree().change_scene_to_file(multi_scene_path)

func _on_single_pressed() -> void:
	UI_loading.visible = true
	get_tree().change_scene_to_file(game_scene_path)
