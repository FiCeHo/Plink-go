extends Node2D

@export var hud : CanvasLayer

var isSetup = true
var initial_position = Vector2(577, 122)
var fallThreshold = 900
var limit = 0

func _process(delta):
	if get_node("RigidBody2D").global_position.y > fallThreshold:
		if limit == 0:
			queue_free()
		else:
			limit -= 1
			respawn()
		
func respawn():
	get_node("RigidBody2D").global_position = initial_position
	get_node("RigidBody2D").gravity_scale = 0.0
	get_node("RigidBody2D").linear_velocity = Vector2.ZERO

	while get_node("RigidBody2D").angular_velocity == 0:
		get_node("RigidBody2D").angular_velocity = randf_range(-5, 5)
	rotation = 0

	isSetup = true


func _on_rigid_body_2d_body_entered(body: Node) -> void:
	hud.call("score_up")
