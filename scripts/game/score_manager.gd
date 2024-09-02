class_name ScoreManager
extends Node

signal reset_ball(spawn: String)
signal exit

@onready var UI_scores: Container = $"../../UI/Scores"
@onready var label_score_A = $"../../UI/Scores/Score A"
@onready var label_score_B = $"../../UI/Scores/Score B"
@onready var score_timer = $Timer
@onready var game_manager = $".."

var score_to_win: int
var score_A: int = 0
var score_B: int = 0
var finished: bool = false
var end_time: int = 3

func _ready():
	UI_scores.visible = false
	score_timer.timeout.connect(_hide_score)

func _process(_delta):
	if finished or (score_A < score_to_win and score_B < score_to_win):
		return

	if score_A >= score_to_win:
		label_score_A.text = "WINS"
		label_score_B.text = "LOSE"
	if score_B >= score_to_win:
		label_score_A.text = "LOSE"
		label_score_B.text = "WINS"
	finished = true
	score_timer.wait_time = end_time
	_show_score()

func _on_goal_A_body_entered(body):
	if body is Ball:
		if game_manager.is_multiplayer:
			_update_score.rpc("A")
		else:
			_update_score("A")

func _on_area_3d_body_entered(_body):
	if game_manager.is_multiplayer:
			_update_score.rpc("B")
	else:
		_update_score("B")

@rpc("any_peer", "call_local", "reliable")
func _update_score(team: String):
	if not score_timer.is_stopped():
		return
	reset_ball.emit(team)
	if team == "A":
		score_A += 1
	if team == "B":
		score_B += 1
	_show_score()

func _show_score():
	if not finished:
		label_score_A.text = str(score_A)
		label_score_B.text = str(score_B)
	UI_scores.visible = true
	if not score_timer.is_stopped():
		score_timer.stop()
	score_timer.start()

func _hide_score():
	UI_scores.visible = false
	if finished:
		exit.emit()
