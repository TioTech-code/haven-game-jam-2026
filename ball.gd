extends CharacterBody2D

@export var speed: float = 350.0
var direction := Vector2(1, -1).normalized()

func _physics_process(delta: float) -> void:
    var collision := move_and_collide(direction * speed * delta)

    if collision:
        direction = direction.bounce(collision.get_normal())
        var collider := collision.get_collider()

        if collider and collider.has_method("hit"):
            collider.call("hit")

    # Keep the ball inside the screen
    if position.x <= 10:
        direction.x = abs(direction.x)
        position.x = 10
    elif position.x >= 950:
        direction.x = -abs(direction.x)
        position.x = 950

<<<<<<< HEAD
    if position.y <= 10:
        direction.y = abs(direction.y)
        position.y = 10
    elif position.y > 550:
        var game := get_tree().current_scene

        if game and game.has_method("ball_lost"):
            game.call("ball_lost")
            return

        reset_ball()
=======
	if position.x <= 10:
		direction.x = abs(direction.x)
		position.x = 10
	elif position.x >= 950:
		direction.x = -abs(direction.x)
		position.x = 950

	if position.y <= 10:
		direction.y = abs(direction.y)
		position.y = 10
	elif position.y > 550:
		var game := get_tree().current_scene

		if game and game.has_method("ball_lost"):
			game.call("ball_lost")
			return

		reset_ball()
>>>>>>> 5fcb1b6643ec6978eb930b739b994a1c97a96588

func reset_ball() -> void:
    position = Vector2(480, 430)
    direction = Vector2(1, -1).normalized()
