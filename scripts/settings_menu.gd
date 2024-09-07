extends Control

@onready var audio_bus_master = 0
@onready var audio_bus_music = 1
@onready var audio_bus_fx = 2

@export_group("Sound")
@export var master_slider: Slider
@export var music_slider: Slider
@export var effects_slider: Slider

@export_group("Gyro")
@export var gyro_slider: Slider

@export_group("Vibration")
@export var vibration_button: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_slider.value = Settings.get_config(Settings.CONFIG_NAMES.master_vol)
	music_slider.value = Settings.get_config(Settings.CONFIG_NAMES.music_vol)
	effects_slider.value = Settings.get_config(Settings.CONFIG_NAMES.fx_vol)
	gyro_slider.value = Settings.get_config(Settings.CONFIG_NAMES.gyro_sens)
	vibration_button.button_pressed = Settings.get_config(Settings.CONFIG_NAMES.vibration)

func _on_lenguage_es_pressed() -> void:
	_set_language_locale("es")

func _on_lenguage_en_pressed() -> void:
	_set_language_locale("en")

func _on_lenguage_ca_pressed() -> void:
	_set_language_locale("ca")

func _set_language_locale(locale_code: String) -> void:
	TranslationServer.set_locale(locale_code)
	Settings.set_config("language", locale_code)

func _on_vibracion_boton_toggled(toggled_on:bool) -> void:
	Settings.set_config("vibration", toggled_on)

func _on_efectos_slider_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_db(audio_bus_fx, linear_to_db(value))
	Settings.set_config("fx_vol", value)

func _on_musica_slider_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_db(audio_bus_music, linear_to_db(value))
	Settings.set_config("music_vol", value)

func _on_vm_slider_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_db(audio_bus_master, linear_to_db(value))
	Settings.set_config("master_vol", value)

func _on_giroscopio_slider_value_changed(value:float) -> void:
	Settings.set_config("gyro_sens", value)

func _on_mute_toggled(toggled_on:bool) -> void:
	AudioServer.set_bus_mute(audio_bus_master, toggled_on)
