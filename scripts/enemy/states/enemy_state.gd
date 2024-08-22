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
var animation_manager: animationManager
var enemy_ia_follow: EnemyIAFollow

func _setup() -> void:
	if not team:
		team = enemy.team
	if not goal:
		goal = team.goal
	if not ball:
		ball = team.ball
		ball_future = ball.future_position_node
	if not agent:
		agent = enemy.nav_agent
	if not hit_manager:
		hit_manager = enemy.hit_manager
	if not animation_manager:
		animation_manager = enemy.animation_manager
	if not enemy_ia_follow:
		enemy_ia_follow = enemy.enemy_ia_follow
