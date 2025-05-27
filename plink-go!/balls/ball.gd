extends Node2D

signal dead()

@export var ui : CanvasLayer
@export var ball_data: BallData
var initial_position : Vector2
var physics_material : PhysicsMaterial
var fallThreshold = 900
var score
var value
var mult
var limit
var gravity
var last_ball = false

func _ready():
	physics_material = PhysicsMaterial.new()
	physics_material.bounce = ball_data.bounce 
	get_node("RigidBody2D").physics_material_override = physics_material
	ball_data.value = ball_data.value + PlayerVariables.perk_boost
	$RigidBody2D/Sprite2D.texture = ball_data.texture
	if ball_data.id != "d20":
		value = ball_data.value
		if ball_data.id != "baseball":
			mult = ball_data.mult
	else:
		_mult_value_d20()
	limit = ball_data.limit
	gravity = ball_data.gravity * PlayerVariables.perk_grav
	
func _mult_value_d20():
	randomize()
	value = randi_range(1, 1000)
	mult = randi_range(1, 1000)

func _process(delta):
	if get_node("RigidBody2D").global_position.y > fallThreshold:
		score = (value * (mult * PlayerVariables.perk_mult)) * (Global.void_multiplier * PlayerVariables.perk_mult)
		ui.call("score_up", score)
		kill()

func kill():
	if ball_data.limit == 0:
		queue_free()
		emit_signal("dead")
	else:
		ball_data.limit -= 1
		respawn()

func respawn():
	get_node("RigidBody2D").global_position = initial_position
	get_node("RigidBody2D").linear_velocity = Vector2.ZERO

	while get_node("RigidBody2D").angular_velocity == 0:
		get_node("RigidBody2D").angular_velocity = randf_range(-5, 5)
	rotation = 0

func _on_rigid_body_2d_body_entered(body: Node) -> void:
	if body.get_parent().name.begins_with("Pin"):
		value += PlayerVariables.perk_bounce
		ui.call("score_up", PlayerVariables.perk_rush)
	if body.get_parent().name.contains("Multiplier"):
		body.get_parent().collision()
		var multiplier = body.get_parent().multiplier
		if PlayerVariables.perk_lifebuoy:
			multiplier = 1
			PlayerVariables.perk_lifebuoy = false
		score = (value * (mult * PlayerVariables.perk_mult)) * (multiplier * PlayerVariables.perk_mult)
		ui.call("score_up", score)
		if last_ball:
			ui.call("jackpot")
		kill()
