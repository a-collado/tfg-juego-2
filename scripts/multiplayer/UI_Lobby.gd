extends Node2D

@onready var menu_lobby: Container = $"Lobby Menu"
@onready var text_name: LineEdit = $"Lobby Menu/Name"
@onready var text_ip: LineEdit = $"Lobby Menu/Ip"

@onready var menu_host: Container = $"Players Menu"
@onready var text_host_player1: Label = $"Players Menu/Player 1"
@onready var text_host_player2: Label = $"Players Menu/Player 2"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)
	Lobby.server_disconnected.connect(_on_server_disconnected)

func _on_host_button_pressed() -> void:
	Lobby.player_info = {"name": text_name.text}
	menu_lobby.hide()
	menu_host.show()
	Lobby.create_game()

func _on_join_button_pressed() -> void:
	Lobby.player_info = {"name": text_name.text}
	menu_lobby.hide()
	menu_host.show()
	Lobby.join_game(text_ip.text)

func _on_player_connected(peer_id: int, player_info: Dictionary) -> void:
	if peer_id == 1:
		text_host_player1.text = player_info.name
	else:
		text_host_player2.text = player_info.name

func _on_player_disconnected(peer_id: int) -> void:
	if peer_id == 1:
		text_host_player1.text = "..."
	else:
		text_host_player2.text = "..."

func _on_server_disconnected() -> void:
	_on_back_pressed()

func _on_back_pressed() -> void:
	Lobby.remove_multiplayer_peer()
	menu_host.hide()
	text_host_player1.text = "..."
	text_host_player2.text = "..."
	menu_lobby.show()

