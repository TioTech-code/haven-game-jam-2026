extends Node2D

var score: int = 0
var blocks_remaining: int = 15
var lives: int = 3
var game_finished: bool = false

@onready var score_label: Label = $HUD/ScoreLabel
@onready var lives_label: Label = $HUD/LivesLabel
@onready var message_label: Label = $HUD/MessageLabel
@onready var restart_button: Button = $HUD/RestartButton

func _ready() -> void:
	update_hud()
	message_label.hide()
	restart_button.hide()
	restart_button.pressed.connect(_on_restart_button_pressed)

func block_destroyed() -> void:
	if game_finished:
		return

	score += 10
	blocks_remaining -= 1
	update_hud()

	if blocks_remaining <= 0:
		end_game(true)

func ball_lost() -> void:
	if game_finished:
		return

	lives -= 1
	update_hud()

	if lives <= 0:
		end_game(false)
	else:
		activate_bounce_back()
		$Ball.reset_ball()

func activate_bounce_back() -> void:
	$Paddle.scale.x = min($Paddle.scale.x + 0.25, 1.5)

	message_label.text = "BOUNCE BACK! PADDLE UPGRADED"
	message_label.show()

	await get_tree().create_timer(1.2).timeout

	if not game_finished:
		message_label.hide()

func update_hud() -> void:
	score_label.text = "Score: " + str(score)
	lives_label.text = "Lives: " + str(lives)

func end_game(player_won: bool) -> void:
	game_finished = true
	$Ball.set_physics_process(false)
	$Paddle.set_physics_process(false)

	if player_won:
		message_label.text = "YOU BOUNCED BACK!"
	else:
		message_label.text = "KEEP GOING — BOUNCE BACK!"

	message_label.show()
	restart_button.show()

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
