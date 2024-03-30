class_name debugDrawer
extends Node3D

var joystick_direction: Vector3;
var joystick_pressed: bool;

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	position = joystick_direction
	if joystick_direction.length() > 0:
		look_at(global_transform.origin + joystick_direction, Vector3.UP)
	if joystick_pressed:
		visible = true
	else:
		visible = false


