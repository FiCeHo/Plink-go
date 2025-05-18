extends Node

@export var ball_array : Array[PackedScene]

var player_scene
var ball_index = 1
var previous_player

func _on_touch_screen_button_2_pressed():
	if previous_player != null:
		previous_player.get_node("RigidBody2D").gravity_scale = previous_player.gravity
		while previous_player.get_node("RigidBody2D").angular_velocity == 0:
			previous_player.get_node("RigidBody2D").angular_velocity = randf_range(-5, 5)
	
	if ball_index < ball_array.size():
		var player = player_scene.instantiate()

		player.global_position = $Game/Container/Marker2D.global_position
		player.hud = get_node("UI")

		add_child(player)
		ball_index += 1
		if ball_index < ball_array.size():
			player_scene = ball_array[ball_index]
		previous_player = player

func _on_ready() -> void:
	player_scene = ball_array[0]
	previous_player = player_scene.instantiate()
	previous_player.global_position = $Game/Container/Marker2D.global_position
	previous_player.hud = get_node("UI")
	add_child(previous_player)
