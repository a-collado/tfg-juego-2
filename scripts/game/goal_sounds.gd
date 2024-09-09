extends Node

@export var goal_sound: AudioStream

var playback:AudioStreamPlaybackPolyphonic

func _ready():
	# Create an audio player
	var player = AudioStreamPlayer.new()
	add_child(player)

	# Create a polyphonic stream so we can play sounds directly from it
	var stream = AudioStreamPolyphonic.new()
	stream.polyphony = 32
	player.stream = stream
	player.volume_db = -15
	player.play()
	# Get the polyphonic playback stream to play sounds
	playback = player.get_stream_playback()
	player.bus = "Efectos"

func _on_score_manager_play_goal_sound() -> void:
	playback.play_stream(goal_sound, 0, 0, randf_range(0.8, 1.2))
