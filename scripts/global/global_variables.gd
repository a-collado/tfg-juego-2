extends Node

@onready var screen_touched: bool = true
@onready var difficulty: int = 1
@onready var goals_to_win = 10

@rpc("authority", "call_local", "reliable")
func set_difficulty(diff: int) -> void:
	difficulty = diff

@rpc("authority", "call_local", "reliable")
func set_goals_to_win(goals: int) -> void:
	goals_to_win = goals
