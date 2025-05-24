extends Node

var ball_array = PlayerVariables.ball_array
var perk_array = PlayerVariables.perk_array

var player_scene
var ball_index = 1
var previous_player
var won = false

@onready var options = $Options

func _unhandled_input(event: InputEvent):
	if event is InputEventScreenTouch:
		if event.pressed:
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
				else:
					player.tree_exited.connect(_end_round)
				previous_player = player

func load_perks():
	if perk_array.has("2xPoints"):
		Global.value_mult = Global.value_mult * 2
	if perk_array.has("1Up"):
		Global.limit_sum += 1
	if perk_array.has("+1Mult"):
		Global.mult_sum += 1

func _ready():
	options.visible = false
	Global.initial_position = $Game/Container/Marker2D.global_position
	load_perks()
	if PlayerVariables.current_round >= 3:
		var next_goal = (Global.goals[PlayerVariables.current_round - 2] * 2) + (Global.goals[PlayerVariables.current_round - 3] * 2)
		Global.goals.append(next_goal)
	$UI.load_goal(Global.goals[PlayerVariables.current_round - 1])
	player_scene = ball_array[0]
	previous_player = player_scene.instantiate()
	previous_player.global_position = Global.initial_position
	previous_player.initial_position = Global.initial_position
	previous_player.hud = get_node("UI")
	add_child(previous_player)

func _end_round():
	if PlayerVariables.current_score >= Global.goals[PlayerVariables.current_round - 1]:
		PlayerVariables.current_round += 1
		$Animation.visible = true
		$Animation/Panel2/AnimationPlayerWin.play("new_animation")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	$WinScreen.layer = 50
	$WinScreen/AnimationPlayer.play("new_animation")

func _on_button_pressed() -> void:
	get_tree().paused = true
	options.layer = 10
	options.visible = true

func _on_back_opts_pressed() -> void:
	options.visible = false
	options.layer = -4
	get_tree().paused = false


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://shop/shop_screen.tscn")
