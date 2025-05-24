extends Node2D

@export var hud : CanvasLayer
@export var ball_data: BallData
var initial_position : Vector2
var physics_material : PhysicsMaterial
var fallThreshold = 900
var score
var limit
var gravity

func _ready():
	physics_material = PhysicsMaterial.new()
	physics_material.bounce = ball_data.bounce
	get_node("RigidBody2D").physics_material_override = physics_material
	ball_data.limit += Global.limit_sum
	ball_data.value = ball_data.value * Global.value_mult
	$RigidBody2D/Sprite2D.texture = ball_data.texture
	score = ball_data.value
	limit = ball_data.limit
	gravity = ball_data.gravity

func _process(delta):
	if get_node("RigidBody2D").global_position.y > fallThreshold:
		score = ball_data.value * Global.void_multiplier
		hud.call("score_up", score)
		kill()

func kill():
	if ball_data.limit == 0:
		queue_free()
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
	#if body.get_parent().name.begins_with("Pin"):
		#var a = 0
	if body.get_parent().name.contains("Multiplier"):
		body.get_parent().collision()
		score = ball_data.value * body.get_parent().multiplier
		hud.call("score_up", score)
		kill()
