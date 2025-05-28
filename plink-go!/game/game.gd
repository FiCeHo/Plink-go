extends Node

var ball_data_array = PlayerVariables.ball_array
var perk_array = PlayerVariables.perk_array
var ball_holders

var player_data
var ball_index = 1
var previous_player
var won = false
var current_goal
@onready var perk_list = $PlayerPerks

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
				player.ui = get_node("UI")
				if player.ball_data.id == "baseball":
					player.mult = 10 * (ball_index + 1)

				$Balls.add_child(player)
				player.connect("dead", _last_ball)
				ball_index += 1

				if ball_index < ball_data_array.size():
					player_data = ball_data_array[ball_index]
				else:
					player.tree_exited.connect(_last_ball)
					player.last_ball = true
				previous_player = player

func _load_player_perks():
	for child in perk_list.get_children():
		child.queue_free()
		
	for perk_data in PlayerVariables.perk_array:
		var item = ShowItem.spawn(perk_data, "perk")
		item.set_meta("source", "player")
		#item.selected.connect(_on_item_selected)
		item.get_node("Holder").self_modulate = Color8(255, 255, 255, 255)
		perk_list.add_child(item)
		
		match perk_data.id:
			"black_hole":
				PlayerVariables.perk_grav *= 2
			"bounce_em":
				PlayerVariables.perk_bounce += 1
			"double_down":
				PlayerVariables.perk_mult *= 2
			"haggler":
				PlayerVariables.perk_sell *= 2
			"jackpot":
				PlayerVariables.perk_jackpot *= 2
			"life_buoy":
				PlayerVariables.perk_lifebuoy = true
			"point_booster":
				PlayerVariables.perk_boost += 100
			"bounce_rush":
				PlayerVariables.perk_rush += 10
			"investor":
				PlayerVariables.perk_interest *= 2
			"quality_magnet":
				PlayerVariables.perk_magnet = true
			"sale_hunter":
				PlayerVariables.perk_reroll *= 2
			"stop":
				PlayerVariables.perk_stop *= 0.9
			

func _ready():
	for i in ball_data_array.size():
		if ball_data_array[i] == null:
			ball_data_array[i] = preload("res://balls/items/pebble.tres")
	PlayerVariables.connect("update_score", _end_round_early)
	current_goal = Global.goals[PlayerVariables.current_round - 1]
	options.visible = false
	PlayerVariables.reset_perks()
	Global.initial_position = $Game/Container/Marker2D.global_position
	_load_player_perks()
	if PlayerVariables.current_round >= 3:
		var next_goal = (Global.goals[PlayerVariables.current_round - 1] * 2) + (Global.goals[PlayerVariables.current_round - 2] * 2 / PlayerVariables.perk_stop)
		Global.goals.append(next_goal)
	Global.goals[PlayerVariables.current_round - 1] *= PlayerVariables.perk_stop
	$UI.load_goal(Global.goals[PlayerVariables.current_round - 1])
	player_data = ball_data_array[0]
	previous_player = ShowItem.spawn(player_data, "ball")
	previous_player.global_position = Global.initial_position
	previous_player.initial_position = Global.initial_position
	previous_player.ui = get_node("UI")
	if previous_player.ball_data.id == "baseball":
		previous_player.mult = 10 * ball_index
	
	$Balls.add_child(previous_player)
	previous_player.connect("dead", _last_ball)
	player_data = ball_data_array[1]
	update_display()

func _end_round_early():
	if PlayerVariables.current_score >= current_goal && !won:
		get_tree().paused = true
		won = true
		var more_money = (3 + (5 - (ball_index - 1))) * PlayerVariables.perk_interest
		$WinScreen/Win/Label.text += str(PlayerVariables.current_round) + " Results"
		PlayerVariables.current_round += 1
		$WinScreen/Win/Points.text += str(PlayerVariables.current_score).split(".")[0] + " / " + str(Global.goals[PlayerVariables.current_round - 2]).split(".")[0]
		$WinScreen/Win/NextGoal.text += str(Global.goals[PlayerVariables.current_round - 1]).split(".")[0]
		$WinScreen/Win/Money.text += str(PlayerVariables.money) + " + " + str(more_money)
		PlayerVariables.money += more_money
		$Animation.visible = true
		$Animation/Panel2/AnimationPlayerWin.play("new_animation")
		
func _end_round():
	if PlayerVariables.current_score >= current_goal && !won:
		get_tree().paused = true
		won = true
		var more_money = (3 + (5 - (ball_index - 1))) * PlayerVariables.perk_interest
		$WinScreen/Win/Label.text += str(PlayerVariables.current_round) + " Results"
		PlayerVariables.current_round += 1
		$WinScreen/Win/Points.text += str(PlayerVariables.current_score).split(".")[0] + " / " + str(Global.goals[PlayerVariables.current_round - 2]).split(".")[0]
		$WinScreen/Win/NextGoal.text += str(Global.goals[PlayerVariables.current_round - 1]).split(".")[0]
		$WinScreen/Win/Money.text += str(PlayerVariables.money) + " + " + str(more_money)
		PlayerVariables.money += more_money
		$Animation.visible = true
		$Animation/Panel2/AnimationPlayerWin.play("new_animation")
	elif PlayerVariables.current_score < current_goal:
		get_tree().paused = true
		$LoseScreen/Lose/Label.text += str(PlayerVariables.current_round) + " Results"
		$LoseScreen/Lose/Points.text += str(PlayerVariables.current_score).split(".")[0] + " / " + str(Global.goals[PlayerVariables.current_round - 1]).split(".")[0]
		$LoseScreen/Lose/Round.text += str(PlayerVariables.current_round)
		$Animation.visible = true
		$Animation/Panel2/AnimationPlayerWin.play("new_animation")
		
func _last_ball():
	var balls = get_node("Balls").get_children()
	if balls.size() == 1:
		_end_round()

func update_display():
	ball_holders = $UI.get_children().filter(is_ball_holder)
	var i = 0
	for ball_holder in ball_holders:
		ball_holder.get_node("Sprite2D").texture = ball_data_array[i].texture
		i += 1
	
func is_ball_holder(node):
	return node.name.contains("Ball_cont")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if won:
		$WinScreen.visible = true
		$WinScreen/AnimationPlayer.play("new_animation")
	else:
		$LoseScreen.visible = true
		$LoseScreen/AnimationPlayer.play("new_animation")

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
	get_tree().paused = false
	get_tree().change_scene_to_file("res://shop/shop_screen.tscn")
