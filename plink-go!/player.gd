extends RigidBody2D

var isSetup = true

func _physics_process(delta):
	if isSetup:
		if Input.is_action_pressed("ui_touch"):
			gravity_scale = 1.0
			isSetup = false
			angular_velocity = randf_range(-5, 5)
