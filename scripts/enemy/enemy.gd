extends CharacterBody3D
class_name Enemy

const SPEED = 10.0

@onready var team: Team = self.get_parent()
@onready var hit_manager: HitManager = $hitManager
@onready var animation_manager: animationManager = $animationManager
@onready var root = $root
@onready var navigator: Navigator = $navigator
@onready var nav_agent: NavigationAgent3D = $navigationAgent
@onready var hit_nodes: Node3D = $hitNodes
@onready var hit_prediction_area: Node3D = $hitNodes/hitPredictionArea

func _physics_process(_delta: float) -> void:
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var direction = (next_location - current_location).normalized()
	direction.y = 0

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		root.look_at(global_transform.origin - direction, Vector3.UP)
		animation_manager.moving()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()


func _on_hit_area_body_entered(body:Node3D) -> void:
	if body is Ball:
		var hit_direction = hit_nodes.global_transform.basis * Vector3.FORWARD
		# Esto hay que cambiarlo e implementar el sistema de carga
		var fuerza_tiro = 50
		body.kick(-1 * hit_direction.normalized() * fuerza_tiro)

