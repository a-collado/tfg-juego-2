class_name debugDrawer
extends Node3D

var joystick_pressed: bool;

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if joystick_pressed:
		visible = true
	else:
		visible = false


