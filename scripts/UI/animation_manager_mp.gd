extends Node

signal back_to_menu


@export_group("Pre Nodes")
@export var lobby_menu_single: Control
@export var lobby_menu_multi: Control
@export var lobby_menu_settings: Control

@export_group("Lobby Menu Nodes")
@export var lobby_menu_name_selector: Control
@export var lobby_menu_create_game: Control
@export var lobby_menu_back: Control
@export var lobby_menu_server: Control
@export var lobby_menu_server_list: VBoxContainer
@export var lobby_menu_direct_connect: Control

@export_group("Player Menu Nodes")
@export var player_menu_title: Control
@export var player_menu_start: Control
@export var player_name_1: Control
@export var player_name_2: Control

func _ready() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(lobby_menu_multi, "position:y",-256, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_single, "position:y", 1045, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_settings, "position:y", 1300, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)

	_set_lobby_menu_in_place(tween)


func _on_lobby_go_back_main_menu() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(lobby_menu_name_selector, "position:y",0, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_create_game, "position:y",0, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_back, "position:y",758, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_server, "position:y",40, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_server_list, "position:y",1433, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_direct_connect, "position:y", 0, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(lobby_menu_multi, "position:y",417, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_single, "position:y", 24, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_settings, "position:y", 899, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished",_go_back_to_menu)

func _go_back_to_menu():
	back_to_menu.emit()

func _set_lobby_menu_in_place(tween: Tween):
	tween.tween_property(lobby_menu_name_selector, "position:y",-1050, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_create_game, "position:y",-930, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_back, "position:y",475, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_server, "position:y",-809, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_server_list, "position:y",585, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_direct_connect, "position:y", -460, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)


func _on_lobby_show_host_menu() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(lobby_menu_name_selector, "position:x",600, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_create_game, "position:x",600, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_server, "position:x",600, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_server_list, "position:x",600, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_direct_connect, "position:x", 600, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(player_menu_title, "position:x", 0, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(player_menu_start, "position:x", 0, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(player_name_1, "position:x", 0, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(player_name_2, "position:x", 0, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)

func _on_lobby_hide_host_menu() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(lobby_menu_name_selector, "position:x",0, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_create_game, "position:x",0, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_server, "position:x",0, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_server_list, "position:x",0, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(lobby_menu_direct_connect, "position:x", 0, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(player_menu_title, "position:x", -600, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(player_menu_start, "position:x", -600, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(player_name_1, "position:x", -600, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(player_name_2, "position:x", -600, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
