extends AudioStreamPlayer

@onready var menu_music : AudioStreamOggVorbis = preload("res://assets/Audio/Musica/Groove Dungeon.ogg")
@onready var game_music : AudioStreamOggVorbis = preload("res://assets/Audio/Musica/ElectroFest.ogg")

func _ready() -> void:
	stream = menu_music
	volume_db = -10
	autoplay = true
	play()
	bus = "Musica"
	playback_type = AudioServer.PlaybackType.PLAYBACK_TYPE_STREAM

	$"/root/StartScreen".connect("tree_exited", _game_entered)

func _game_entered() -> void:
	if get_tree():
		await get_tree().process_frame

	if(get_node_or_null("/root/Game")):
		stop()
		stream = game_music
		play()

func _game_exited() -> void:
	if get_tree():
		await get_tree().process_frame

	if(get_node_or_null("/root/StartScreen")):
		if not $"/root/StartScreen".is_connected("tree_exited", _game_entered):
			$"/root/StartScreen".connect("tree_exited", _game_entered)
	stop()
	stream = menu_music
	play()
