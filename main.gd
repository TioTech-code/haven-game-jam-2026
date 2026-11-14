extends Node2D

var game_started: bool = false
var score: int = 0
var blocks_remaining: int = 15
var lives: int = 3
var game_finished: bool = false

@onready var score_label: Label = $HUD/ScoreLabel
@onready var lives_label: Label = $HUD/LivesLabel
@onready var message_label: Label = $HUD/MessageLabel
@onready var restart_button: Button = $HUD/RestartButton

@onready var block_sound: AudioStreamPlayer = $BlockSound
@onready var life_sound: AudioStreamPlayer = $LifeSound
@onready var victory_sound: AudioStreamPlayer = $VictorySound

func _ready() -> void:
	update_hud()
	restart_button.hide()

	message_label.text = "PRESS SPACE TO START"
	message_label.show()

	$Ball.set_physics_process(false)
	restart_button.pressed.connect(_on_restart_button_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if (
		not game_started
		and not game_finished
		and event.is_action_pressed("ui_accept")
	):
		game_started = true
		message_label.hide()
		$Ball.set_physics_process(true)

func block_destroyed() -> void:
	if game_finished:
		return

	block_sound.play()
	score += 10
	blocks_remaining -= 1
	update_hud()

	if blocks_remaining <= 0:
		end_game(true)

func ball_lost() -> void:
	if game_finished:
		return

	life_sound.play()
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
		victory_sound.play()
	else:
		message_label.text = "KEEP GOING — BOUNCE BACK!"

	message_label.show()
	restart_button.show()

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
