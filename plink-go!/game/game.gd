extends Node

var ball_data_array = PlayerVariables.ball_array
var perk_array = PlayerVariables.perk_array
var ball_holders

var player_data
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
			
			ball_holders[ball_index - 1].get_node("Sprite2D").modulate = Color8(255, 255, 255, 127)
			
			if ball_index < ball_data_array.size():
				var player = ShowItem.spawn(player_data, "ball")

				player.global_position = $Game/Container/Marker2D.global_position
				player.initial_position = $Game/Container/Marker2D.global_position
				player.hud = get_node("UI")

				add_child(player)
				ball_index += 1
				if ball_index < ball_data_array.size():
					player_data = ball_data_array[ball_index]
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
	PlayerVariables.connect("update_score", _end_round)
	options.visible = false
	Global.initial_position = $Game/Container/Marker2D.global_position
	load_perks()
	if PlayerVariables.current_round >= 3:
		var next_goal = (Global.goals[PlayerVariables.current_round - 1] * 2) + (Global.goals[PlayerVariables.current_round - 2] * 2)
		Global.goals.append(next_goal)
	$UI.load_goal(Global.goals[PlayerVariables.current_round - 1])
	player_data = ball_data_array[0]
	previous_player = ShowItem.spawn(player_data, "ball")
	previous_player.global_position = Global.initial_position
	previous_player.initial_position = Global.initial_position
	previous_player.hud = get_node("UI")
	add_child(previous_player)
	update_display()

func _end_round():
	if PlayerVariables.current_score >= Global.goals[PlayerVariables.current_round - 1] && !won:
		won = true
		var more_money = 3 + (5 - (ball_index - 1))
		PlayerVariables.current_round += 1
		$WinScreen/Win/Points.text += str(PlayerVariables.current_score).split(".")[0] + " / " + str(Global.goals[PlayerVariables.current_round - 2])
		$WinScreen/Win/NextGoal.text += str(Global.goals[PlayerVariables.current_round - 1])
		$WinScreen/Win/Money.text += str(PlayerVariables.money) + " + " + str(more_money)
		PlayerVariables.money += more_money
		$Animation.visible = true
		$Animation/Panel2/AnimationPlayerWin.play("new_animation")

func update_display():
	ball_holders = $UI.get_children().filter(is_ball_holder)
	var i = 0
	for ball_holder in ball_holders:
		ball_holder.get_node("Sprite2D").texture = ball_data_array[i].texture
		i += 1
	
func is_ball_holder(node):
	return node.name.contains("Ball_cont")

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
