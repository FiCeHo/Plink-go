extends Node

@export var player_scene: PackedScene

var ball_limit = 4
var previous_player

func _on_touch_screen_button_2_pressed():
	if previous_player != null:
		previous_player.get_node("RigidBody2D").gravity_scale = 3.5
		while previous_player.get_node("RigidBody2D").angular_velocity == 0:
			previous_player.get_node("RigidBody2D").angular_velocity = randf_range(-5, 5)
	
	if ball_limit > 0:
		var player = player_scene.instantiate()

		player.global_position = Vector2(577, 122)
		player.hud = get_node("HUD")

		add_child(player)
		print(ball_limit)
		ball_limit -= 1
		previous_player = player

func _on_ready() -> void:
	previous_player = player_scene.instantiate()
	previous_player.global_position = Vector2(577, 122)
	previous_player.hud = get_node("HUD")
	add_child(previous_player)
