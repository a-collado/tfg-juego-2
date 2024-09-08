extends AudioStreamPlayer

@onready var menu_music : AudioStreamOggVorbis = preload("res://assets/Audio/Musica/Groove Dungeon.ogg")

func _ready() -> void:
	stream = menu_music
	volume_db = -10
	autoplay = true
	play()
	bus = "Musica"
	playback_type = AudioServer.PlaybackType.PLAYBACK_TYPE_STREAM

	$"/root/StartScreen".connect("tree_exited", _game_entered)

func _game_entered() -> void:
	await get_tree().process_frame

	if($"/root/Game"):
		$"/root/Game".connect("tree_exited", _game_exited)
		stop()

func _game_exited() -> void:
	play()

