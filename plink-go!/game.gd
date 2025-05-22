extends Node

var ball_array = PlayerVariables.ball_array
var perk_array = PlayerVariables.perk_array

var player_scene
var ball_index = 1
var previous_player

func _on_touch_screen_button_2_pressed():
	print("nig")
	if previous_player != null:
		previous_player.get_node("RigidBody2D").gravity_scale = previous_player.gravity
		while previous_player.get_node("RigidBody2D").angular_velocity == 0:
			previous_player.get_node("RigidBody2D").angular_velocity = randf_range(-5, 5)
	
	if ball_index < ball_array.size():
		var player = player_scene.instantiate()

		player.global_position = $Game/Container/Marker2D.global_position
		player.initial_position = $Game/Container/Marker2D.global_position
		player.hud = get_node("UI")

		add_child(player)
		ball_index += 1
		if ball_index < ball_array.size():
			player_scene = ball_array[ball_index]
		previous_player = player
		
func _process(_delta):
	if PlayerVariables.current_score >= Global.goals[PlayerVariables.current_round - 1]:
		PlayerVariables.current_score = 0
		PlayerVariables.current_round += 1
		get_tree().change_scene_to_file("res://main_menu.tscn")

func load_perks():
	if perk_array.has("2xPoints"):
		Global.value_mult = Global.value_mult * 2
	if perk_array.has("1Up"):
		Global.limit_sum += 1
	if perk_array.has("+1Mult"):
		Global.mult_sum += 1

func _ready():
	Global.initial_position = $Game/Container/Marker2D.global_position
	load_perks()
	$UI.load_goal(Global.goals[PlayerVariables.current_round - 1])
	player_scene = ball_array[0]
	previous_player = player_scene.instantiate()
	previous_player.global_position = Global.initial_position
	previous_player.initial_position = Global.initial_position
	previous_player.hud = get_node("UI")
	add_child(previous_player)
