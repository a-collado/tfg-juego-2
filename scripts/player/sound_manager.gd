class_name SoundManager
extends Node

@export var baseball_swing_1: AudioStream
@export var baseball_swing_2: AudioStream
@export var baseball_swing_3: AudioStream

var playback:AudioStreamPlaybackPolyphonic

func _ready():
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

@rpc("any_peer", "call_local")
func play_bat_swing_sound(charge_level: int) -> void:
	var sound: AudioStream
	match charge_level:
		1: sound = baseball_swing_1
		2: sound = baseball_swing_2
		3: sound = baseball_swing_3

	playback.play_stream(sound, 0, 0, randf_range(0.8, 1.2))
