extends StaticBody2D

@export var challenge_name: String = "SETBACK"
@export var block_color: Color = Color("#8B5CF6")

@onready var challenge_label: Label = $ChallengeLabel

func _ready() -> void:
	challenge_label.text = challenge_name
	queue_redraw()

func _draw() -> void:
	var block_shape := Rect2(-55, -12, 110, 24)
	draw_rect(block_shape, block_color, true)
	draw_rect(block_shape, Color("#FFFFFF"), false, 2.0)

func hit() -> void:
	var game := get_tree().current_scene

	if game.has_method("block_destroyed"):
		game.call("block_destroyed")

	queue_free()
