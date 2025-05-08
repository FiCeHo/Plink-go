extends Node

@export var player_scene: PackedScene

func _on_touch_screen_button_2_pressed():
	# Create a new instance of the player scene.
	var player = player_scene.instantiate()

	# Set the player's position to the random location.
	player.global_position.x = 577
	player.global_position.y = 122
	player.hud = get_node("HUD")

	# Choose the velocity for the player.
	#var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	#player.linear_velocity = velocity.rotated(direction)

	# Spawn the player by adding it to the Main scene.
	add_child(player)
