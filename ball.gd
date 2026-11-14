extends CharacterBody2D

@export var speed: float = 350.0
var direction := Vector2(1, -1).normalized()

func _physics_process(delta: float) -> void:
	var collision := move_and_collide(direction * speed * delta)

	if collision:
		direction = direction.bounce(collision.get_normal())
		var collider := collision.get_collider() as Node2D

		if collider and collider.name == "Paddle":
			var paddle_half_width: float = 58.0 * collider.scale.x
			var hit_offset: float = (
				position.x - collider.position.x
			) / paddle_half_width

			hit_offset = clamp(hit_offset, -1.0, 1.0)
			direction = Vector2(hit_offset, -1.0).normalized()

		elif collider and collider.has_method("hit"):
			collider.call("hit")

	# Keep the ball inside the left and right boundaries
	if position.x <= 10:
		direction.x = abs(direction.x)
		position.x = 10
	elif position.x >= 950:
		direction.x = -abs(direction.x)
		position.x = 950

	# Keep the ball inside the top or register a lost ball
	if position.y <= 10:
		direction.y = abs(direction.y)
		position.y = 10
	elif position.y > 550:
		var game := get_tree().current_scene

		if game and game.has_method("ball_lost"):
			game.call("ball_lost")
			return

		reset_ball()

func reset_ball() -> void:
	position = Vector2(480, 430)
	direction = Vector2(1, -1).normalized()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 10.0, Color("#FACC15"))
	draw_arc(
		Vector2.ZERO,
		10.0,
		0,
		TAU,
		32,
		Color("#FFFFFF"),
		2.0
	)
