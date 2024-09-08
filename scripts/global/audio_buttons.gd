extends Node

var playback:AudioStreamPlaybackPolyphonic

@onready var click_button: AudioStreamOggVorbis = preload("res://assets/Audio/FX/Menus/click_002.ogg")

func _enter_tree() -> void:
	# Create an audio player
	var player = AudioStreamPlayer.new()
	add_child(player)

	# Create a polyphonic stream so we can play sounds directly from it
	var stream = AudioStreamPolyphonic.new()
	stream.polyphony = 32
	player.stream = stream
	player.play()
	# Get the polyphonic playback stream to play sounds
	playback = player.get_stream_playback()
	player.bus = "Efectos"

	get_tree().node_added.connect(_on_node_added)


func _on_node_added(node:Node) -> void:
	if node is Button:
		# If the added node is a button we connect to its mouse_entered and pressed signals
		# and play a sound
		node.pressed.connect(_play_pressed)

func _play_pressed() -> void:
	playback.play_stream(click_button, 0, 0, randf_range(0.9, 1.1))
