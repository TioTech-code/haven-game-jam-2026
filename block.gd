extends StaticBody2D

func hit() -> void:
	var game := get_tree().current_scene

	if game.has_method("block_destroyed"):
		game.call("block_destroyed")

	queue_free()
