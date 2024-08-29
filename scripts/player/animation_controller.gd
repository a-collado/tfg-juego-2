class_name animationManager
extends Node3D

const TREE_CONDITIONS = "parameters/conditions/"
const HIT_ANIMATION_NAME = "jammo_library/bat"

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var bat_tray_animation_player: AnimationPlayer = $"../hitNodes/hitDirection/Trail/AnimationPlayer"
#@onready var hit_area: Area3D = $"../hitNodes/hitArea"

var is_moving: bool = false
var is_idle: bool = true
var hit_ball: bool = false
var hit_animation_happening = false

func _process(_delta):
	animation_tree.set(TREE_CONDITIONS + "is_moving", is_moving)
	animation_tree.set(TREE_CONDITIONS + "is_idle", is_idle)

	animation_tree.set(TREE_CONDITIONS + "hit_ball", hit_ball)
	if hit_ball:
		bat_tray_animation_player.play("swing")
		hit_ball = not hit_ball

func moving():
	is_moving = true
	is_idle = false

func idle():
	is_moving = false
	is_idle = true

func hit(_charge_level: int):
	hit_ball = true

func is_hitting() -> bool:
	return hit_animation_happening

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == HIT_ANIMATION_NAME:
		hit_animation_happening = false

func _on_animation_tree_animation_started(anim_name:StringName) -> void:
	if anim_name == HIT_ANIMATION_NAME:
		hit_animation_happening = true


