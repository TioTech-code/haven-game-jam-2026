extends Node2D

var score: int = 0
var blocks_remaining: int = 15

@onready var score_label: Label = $HUD/ScoreLabel

func _ready() -> void:
	update_score()

func block_destroyed() -> void:
	score += 10
	blocks_remaining -= 1
	update_score()

func update_score() -> void:
	score_label.text = "Score: " + str(score)
