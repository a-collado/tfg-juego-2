class_name ChargeBar
extends Control

signal charge_complete

@onready var texture_progress_bar = $TextureProgressBar
var charging = false

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	texture_progress_bar.value = 0;

func _physics_process(delta):
	if charging:
		show()
		texture_progress_bar.value += 0.01
		if texture_progress_bar.value >= texture_progress_bar.max_value:
			charge_complete.emit()
			charge(false)


func charge(value: bool):
	charging = value;

func reset():
	hide()
	texture_progress_bar.value = 0
