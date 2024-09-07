extends Node

const CONFIG_FILE: String = "user://config.cfg"
const PREFERENCES: String = "preferences"

enum CONFIG_NAMES {
	name, gyro_sens, vibration, master_vol, music_vol, fx_vol, language, first_time
}

var config_data: Dictionary = {}

func _ready():
	if not _load_config():
		_set_default_config()
		_load_config()
	print(config_data)

func _load_config() -> int:
	var config = ConfigFile.new()

	var err = config.load(CONFIG_FILE)

	if err != OK:
		return 0

	for preferences in config.get_sections():
		config_data[CONFIG_NAMES.name] = config.get_value(preferences, "name")
		config_data[CONFIG_NAMES.gyro_sens] = config.get_value(preferences, "gyro_sens")
		config_data[CONFIG_NAMES.language] = config.get_value(preferences, "language")
		config_data[CONFIG_NAMES.vibration] = config.get_value(preferences, "vibration")
		config_data[CONFIG_NAMES.master_vol] = config.get_value(preferences, "master_vol")
		config_data[CONFIG_NAMES.music_vol] = config.get_value(preferences, "music_vol")
		config_data[CONFIG_NAMES.fx_vol] = config.get_value(preferences, "fx_vol")
		config_data[CONFIG_NAMES.first_time] = config.get_value(preferences, "first_time")

	return 1

func _set_default_config() -> void:
	var config = ConfigFile.new()

	config.set_value(PREFERENCES, "name", "")
	config.set_value(PREFERENCES, "gyro_sens", 0.4)
	config.set_value(PREFERENCES, "vibration", true)
	config.set_value(PREFERENCES, "master_vol", 1)
	config.set_value(PREFERENCES, "music_vol", 1)
	config.set_value(PREFERENCES, "fx_vol", 1)
	config.set_value(PREFERENCES, "language", TranslationServer.get_locale())
	config.set_value(PREFERENCES, "first_time", true)

	config.save(CONFIG_FILE)

func get_config(config_name: CONFIG_NAMES):
	return config_data[config_name]

func set_config(config_name: String, value):
	var config = ConfigFile.new()

	var err = config.load(CONFIG_FILE)

	if err != OK:
		return

	config.set_value(PREFERENCES, config_name, value)
	config.save(CONFIG_FILE)
	_load_config()
