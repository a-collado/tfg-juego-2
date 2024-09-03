extends Control

signal go_back_main_menu


@onready var menu_host: Container = $"Players Menu"
@onready var text_host_player1: Label = $"Players Menu/Player 1"
@onready var text_host_player2: Label = $"Players Menu/Player 2"
@onready var button_start: Button = $"Players Menu/Start"
@onready var timer: Timer = $Timer

@onready var server_browser = $"Server List LAN/Server Browser"
@onready var menu_server_list: Container = $"Server List LAN"
@onready var menu_servers: Container = $"Server List LAN/List"

@export_group("Main Menu")
@export var text_name: LineEdit
@export var menu_lobby: Control
@export var button_host: Button
@export var text_ip: LineEdit
@export var button_join: Button

@export_file("*.tscn") var game_scene_path: String = "res://scenes/game-mp.tscn"
@export_file("*.tscn") var start_screen_scene_path: String = "res://scenes/startScreen.tscn"

var change_scene: bool = false

func _ready() -> void:
	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)
	Lobby.server_disconnected.connect(_on_server_disconnected)
	text_name.text = Settings.get_config(Settings.CONFIG_NAMES.name)
	button_start.disabled = true

func _on_host_button_pressed() -> void:
	Lobby.player_info = {"name": text_name.text}
	if(Lobby.create_game() == null):
		menu_lobby.hide()
		menu_host.show()
		server_browser.set_up_broadcast(text_name.text)
		button_start.disabled = true

func _on_join_button_pressed() -> void:
	_connect_to_server(text_ip.text)

func _on_player_connected(peer_id: int, player_info: Dictionary) -> void:
	if peer_id == 1:
		text_host_player1.text = player_info.name
	else:
		text_host_player2.text = player_info.name
	if Lobby.is_server() && Lobby.players.size() == 2:
		button_start.disabled = false

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
	menu_host.hide()
	server_browser.clean_up_broadcast()
	text_host_player1.text = "..."
	text_host_player2.text = "..."
	menu_lobby.show()

func _on_start_pressed() -> void:
	Lobby.load_game.rpc(game_scene_path)

func _on_list_pressed() -> void:
	_clean_server_list()
	menu_lobby.hide()
	server_browser.set_up_listening()
	menu_server_list.show()

func _on_server_list_back_pressed() -> void:
	menu_server_list.hide()
	server_browser.clean_up_listening()
	_clean_server_list()
	menu_lobby.show()

func _clean_server_list() -> void:
	for n in menu_servers.get_children():
		n.queue_free()

func _on_name_text_changed(new_text: String) -> void:
	#Settings.set_config("name", new_text)
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
	if text_host_player1.text == "..." && menu_host.is_visible_in_tree():
		_on_back_pressed()

func _on_server_browser_server_found(server_ip: String, player_name: String) -> void:
	print("Server found on IP: " + server_ip)
	var button_server:ServerButton = ServerButton.new(server_ip, player_name)
	button_server.server_pressed.connect(_connect_to_server)
	menu_servers.add_child(button_server)

func _connect_to_server(server_ip: String):
	Lobby.player_info = {"name": text_name.text}
	if (!Lobby.join_game(server_ip)):
		menu_lobby.hide()
		menu_server_list.hide()
		menu_host.show()
		timer.start()

func _on_reload_pressed() -> void:
	_clean_server_list()
	server_browser.clean_up_listening()
	server_browser.set_up_listening()

func _on_back_title_pressed() -> void:
	go_back_main_menu.emit()

func _on_animation_manager_back_to_menu() -> void:
	ResourceLoader.load_threaded_request(start_screen_scene_path)
	change_scene = true

func _process(_delta):

	var loading_status = ResourceLoader.load_threaded_get_status(start_screen_scene_path)
	if change_scene and loading_status == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(start_screen_scene_path))
