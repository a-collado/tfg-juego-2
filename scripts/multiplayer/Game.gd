class_name MultiplayerGame
extends Node
##
# Este nodo se encarga de asegurase de que los dos jugadores estan sincronizados
# antes de empezar la partida. Spawnea a los dos jugadores y cuando ya han cargado
# se asegura de enviar una señal para empezar la partida.
##

signal end_loading

@onready var UI_loading = $UI/Loading
@export var player_ps: PackedScene = preload("res://objects/player_mp.tscn")
@onready var UI_score: Container = $UI/Scores
@onready var joystick: VirtualJoystick = %"Virtual Joystick"

@onready var score_label_A = $"UI/Scores/Score A"
@onready var score_label_B = $"UI/Scores/Score B"

func _ready():
	UI_loading.visible = true

	Lobby.player_loaded.rpc_id(1) # Tell the server that this peer has loaded.

# Called only on the server.
func start_game():
	# All peers are ready to receive RPCs in this scene.
	print("Ahora empieza el juego")
	end_load_screen.rpc()

func _spawn_players() -> void:

	for p in Lobby.players:
		var player = player_ps.instantiate()
		player.virtual_joystick = joystick
		player.id = int(p)

		var spawn: Marker3D
		var team: Team
		if player.id == 1:
			spawn = $"Team B/Spawn 2"
			team = $"Team B"
			player.name = "Player 1"
			%"Camera 1".current = true
			UI_score.move_child(score_label_A, 0)
		else:
			spawn = $"Team A/Spawn 1"
			team = $"Team A"
			player.name = "Player 2"
			%"Camera 2".current = true
			UI_score.move_child(score_label_B, 0)

		player.position = spawn.position
		player.rotation = spawn.rotation
		team.add_child(player, true)

@rpc("authority", "call_local", "reliable")
func end_load_screen() -> void:
	_spawn_players()
	end_loading.emit()
