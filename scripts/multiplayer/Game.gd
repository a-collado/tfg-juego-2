extends Node

@onready var UI_loading = $UI/Loading

func _ready():
	UI_loading.visible = true
	Lobby.player_loaded.rpc_id(1) # Tell the server that this peer has loaded.

# Called only on the server.
func start_game():
	# All peers are ready to receive RPCs in this scene.
	print("Ahora empieza el juego")
	end_load_screen.rpc()

@rpc("authority", "call_local", "reliable")
func end_load_screen() -> void:
	UI_loading.visible = false
