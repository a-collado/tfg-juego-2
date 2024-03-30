class_name animationManager
extends Node3D

const TREE_CONDITIONS = "parameters/conditions/"

@onready var animation_tree: AnimationTree = $AnimationTree

var is_moving: bool = false;
var is_idle: bool = true;
var hit_ball: bool = false;

func _process(_delta):
	animation_tree.set(TREE_CONDITIONS + "is_moving", is_moving)
	animation_tree.set(TREE_CONDITIONS + "is_idle", is_idle)
	animation_tree.set(TREE_CONDITIONS + "hit_ball", hit_ball)
	if hit_ball:
		hit_ball = not hit_ball

func moving():
	is_moving = true
	is_idle = false

func idle():
	is_moving = false
	is_idle = true

func hit():
	hit_ball = true

