extends State
class_name Defend

@onready var enemy: Enemy = get_parent().get_parent()
var team: Team
var goal: Area3D
var ball: Ball
var ball_future: Node3D
var navigator: Navigator
var agent: NavigationAgent3D

func enter():
	LogDuck.d("[color=#ff2c2c][b]Defend state entered[/b][/color]")
	if not team:
		team = enemy.team
	if not goal:
		goal = team.goal
	if not ball:
		ball = team.ball
		ball_future = ball.future_position_node
	if not navigator:
		navigator = enemy.navigator
	if not agent:
		agent = enemy.nav_agent

func exit():
	pass

func update():
	pass

func physics_update():
	#var direction = ball.transform.origin - enemy.transform.origin
	#navigator.setNavInput(direction)
	agent.target_position = ball_future.transform.origin

## Quizas esto habria que moverlo a otro lado
## Y si no, hacer que solo se pueda ejecutar si estas en este estado
func _on_hit_prediction_area_area_entered(_area:Area3D) -> void:
	enemy.animation_manager.hit(1)

