extends State
class_name EnemyState

@onready var enemy: Enemy = get_parent().get_parent()
var team: Team
var goal: Area3D
var ball: Ball
var ball_future: Node3D
var navigator: Navigator
var agent: NavigationAgent3D
var hit_manager: HitManager

func _setup() -> void:
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
	if not hit_manager:
		hit_manager = enemy.hit_manager
