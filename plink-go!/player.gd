extends RigidBody2D

var isSetup = true
var initial_position: Vector2
var fallThreshold = 700

func _ready():
	initial_position = global_position
	
func _physics_process(delta):
	if isSetup:
		if Input.is_action_pressed("ui_touch"):
			gravity_scale = 3.5
			isSetup = false
			angular_velocity = randf_range(-5, 5)
		else:
			_process(delta)
			
func _process(delta):
	if global_position.y > fallThreshold:
		respawn()
		
func respawn():
	global_position = initial_position
	gravity_scale = 0.0
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	rotation = 0
	isSetup = true
