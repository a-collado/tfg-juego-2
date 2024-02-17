extends Control

@export_file("*.tscn") var game_scene_path: String = "res://scenes/game.tscn"
@export_file("*.tscn") var lan_scene_path: String = "res://scenes/lobby.tscn"

func _on_singleplayer_pressed() -> void:
	get_tree().change_scene_to_file(game_scene_path)

func _on_lan_pressed() -> void:
	get_tree().change_scene_to_file(lan_scene_path)
