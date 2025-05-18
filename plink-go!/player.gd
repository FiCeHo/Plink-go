extends Node2D

@export var hud : CanvasLayer

var isSetup = true
var initial_position : Vector2
var physics_material : PhysicsMaterial
var fallThreshold = 900
var limit = 0
var value = 10
var bounce = 0.64
var gravity = 5

func _on_ready() -> void:
	initial_position = global_position
	physics_material = PhysicsMaterial.new()
	physics_material.bounce = bounce
	get_node("RigidBody2D").physics_material_override = physics_material

func _process(delta):
	if get_node("RigidBody2D").global_position.y > fallThreshold:
		if limit == 0:
			queue_free()
		else:
			limit -= 1
			respawn()
		
func respawn():
	get_node("RigidBody2D").global_position = initial_position
	get_node("RigidBody2D").linear_velocity = Vector2.ZERO

	while get_node("RigidBody2D").angular_velocity == 0:
		get_node("RigidBody2D").angular_velocity = randf_range(-5, 5)
	rotation = 0

func _on_rigid_body_2d_body_entered(body: Node) -> void:
	hud.call("score_up", value)
