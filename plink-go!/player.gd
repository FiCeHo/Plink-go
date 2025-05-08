extends Node2D

@export var hud : CanvasLayer

var isSetup = true
var initial_position: Vector2
var fallThreshold = 900
var limit = 4

func _ready():
	initial_position = get_node("RigidBody2D").global_position

func _physics_process(delta):
	if isSetup:
		if Input.is_action_pressed("ui_touch"):
			get_node("RigidBody2D").gravity_scale = 3.5
			isSetup = false
			while get_node("RigidBody2D").angular_velocity == 0:
				get_node("RigidBody2D").angular_velocity = randf_range(-5, 5)
		else:
			_process(delta)
			
func _process(delta):
	if get_node("RigidBody2D").global_position.y > fallThreshold:
		respawn()
		if limit == 0:
			queue_free()
		else:
			limit -= 1
		
func respawn():
	get_node("RigidBody2D").global_position = initial_position
	get_node("RigidBody2D").gravity_scale = 0.0
	get_node("RigidBody2D").linear_velocity = Vector2.ZERO

	get_node("RigidBody2D").angular_velocity = 0
	rotation = 0
	#isSetup = true

	isSetup = true


func _on_rigid_body_2d_body_entered(body: Node) -> void:
	hud.call("score_up")
