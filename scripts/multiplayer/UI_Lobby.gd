extends Control

signal go_back_main_menu
signal show_host_menu
signal hide_host_menu
signal show_config_menu
signal hide_config_menu

@onready var menu_host: Container = $"Players Menu"
@onready var timer: Timer = $Timer

@onready var server_browser = $"Server List LAN/Server Browser"
@onready var UI_loading = $Loading

@export_group("Main Menu")
@export var text_name: LineEdit
@export var menu_lobby: Control
@export var button_host: Button
@export var text_ip: LineEdit
@export var button_join: Button

@export_group("Player Menu")
@export var button_start: Button
@export var button_settings: Button
@export var text_host_player1: Label
@export var text_host_player2: Label

@export_group("List Menu")
@export var menu_servers: Container

@export_group("Scenes")
@export_file("*.tscn") var game_scene_path: String = "res://scenes/game-mp.tscn"
@export_file("*.tscn") var start_screen_scene_path: String = "res://scenes/startScreen.tscn"
var server_button = preload("res:///objects/serverButton.tscn")

var change_scene: bool = false
var player_menu: bool = false
var settings: bool = false

func _ready() -> void:
	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)
	Lobby.server_disconnected.connect(_on_server_disconnected)
	Lobby.load_game_signal.connect(_load_game)
	text_name.text = Settings.get_config(Settings.CONFIG_NAMES.name)
	button_start.disabled = true
	button_settings.disabled = true
	server_browser.set_up_listening()

func _on_host_button_pressed() -> void:
	Lobby.player_info = {"name": text_name.text}
	if(Lobby.create_game() == null):
		player_menu = true
		show_host_menu.emit()
		server_browser.clean_up_listening()
		#menu_lobby.hide()
		#menu_host.show()
		server_browser.set_up_broadcast(text_name.text)
		button_start.disabled = true
		button_settings.disabled = false

func _on_join_button_pressed() -> void:
	_connect_to_server(text_ip.text)

func _on_player_connected(peer_id: int, player_info: Dictionary) -> void:
	if peer_id == 1:
		text_host_player1.text = player_info.name
	else:
		text_host_player2.text = player_info.name
	if Lobby.is_server() && Lobby.players.size() == 2:
		button_start.disabled = false
	if Lobby.is_server():
		button_settings.disabled = false

func _on_player_disconnected(peer_id: int) -> void:
	if peer_id == 1:
		text_host_player1.text = "..."
	else:
		text_host_player2.text = "..."
	button_start.disabled = true

func _on_server_disconnected() -> void:
	button_start.disabled = true
	_on_back_pressed()

func _on_back_pressed() -> void:
	Lobby.remove_multiplayer_peer()
	#menu_host.hide()
	hide_host_menu.emit()
	server_browser.clean_up_broadcast()
	_clean_server_list()
	text_host_player1.text = "..."
	text_host_player2.text = "..."
	#menu_lobby.show()

func _on_start_pressed() -> void:
	Lobby.load_game.rpc(game_scene_path)

func _on_list_pressed() -> void:
	_clean_server_list()
	#menu_lobby.hide()
	server_browser.set_up_listening()
	#menu_server_list.show()

func _on_server_list_back_pressed() -> void:
	#menu_server_list.hide()
	server_browser.clean_up_listening()
	_clean_server_list()
	#menu_lobby.show()

func _clean_server_list() -> void:
	for n in menu_servers.get_children():
		n.queue_free()

func _on_name_text_changed(new_text: String) -> void:
	Settings.set_config("name", new_text)
	if (new_text == ""):
		button_host.disabled = true
		button_join.disabled = true
	else:
		button_host.disabled = false
		button_join.disabled = false

func _on_ip_text_changed(new_text: String) -> void:
	if (new_text == ""):
		button_join.disabled = true
	else:
		button_join.disabled = false

func _on_timer_timeout() -> void:
	if text_host_player1.text == "..." && player_menu:
		_on_back_pressed()

func _on_server_browser_server_found(server_ip: String, player_name: String) -> void:
	print("Server found on IP: " + server_ip)
	#var button_server: ServerButton = ServerButton.new(server_ip, player_name)
	var button_server: ServerButton = server_button.instantiate()
	button_server.init(server_ip, player_name)
	button_server.server_pressed.connect(_connect_to_server)
	menu_servers.add_child(button_server)

func _connect_to_server(server_ip: String):
	Lobby.player_info = {"name": text_name.text}
	if (!Lobby.join_game(server_ip)):
		#menu_lobby.hide()
		#menu_server_list.hide()
		#menu_host.show()
		server_browser.clean_up_listening()
		player_menu = true
		show_host_menu.emit()
		timer.start()

func _on_reload_pressed() -> void:
	_clean_server_list()
	server_browser.clean_up_listening()
	server_browser.set_up_listening()

func _on_back_title_pressed() -> void:
	if player_menu and not settings:
		_on_back_pressed()
		server_browser.set_up_listening()
		player_menu = false
	elif settings:
		settings = false
		hide_config_menu.emit()
	else:
		go_back_main_menu.emit()

func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		_on_back_title_pressed()
	
func _on_animation_manager_back_to_menu() -> void:
	ResourceLoader.load_threaded_request(start_screen_scene_path)
	change_scene = true

func _process(_delta):
	var loading_status = ResourceLoader.load_threaded_get_status(start_screen_scene_path)
	if change_scene and loading_status == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(start_screen_scene_path))

	loading_status = ResourceLoader.load_threaded_get_status(game_scene_path)
	if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(game_scene_path))

func _on_configure_pressed() -> void:
	settings = true
	show_config_menu.emit()

func _on_low_toggled(_toggled_on:bool) -> void:
	Variables.set_difficulty.rpc(0)

func _on_mid_toggled(_toggled_on:bool) -> void:
	Variables.set_difficulty.rpc(1)

func _on_top_toggled(_toggled_on:bool) -> void:
	Variables.set_difficulty.rpc(2)

func _on_low_goals_toggled(_toggled_on:bool) -> void:
	Variables.set_goals_to_win.rpc(5)

func _on_mid_goals_toggled(_toggled_on:bool) -> void:
	Variables.set_goals_to_win.rpc(10)

func _on_top_goals_toggled(_toggled_on:bool) -> void:
	Variables.set_goals_to_win.rpc(15)

func _load_game(game_scene_path_signal) -> void:
	UI_loading.visible = true
	ResourceLoader.load_threaded_request(game_scene_path_signal)
