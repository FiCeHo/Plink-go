extends Node2D

var multiplier : float

func _ready() -> void:
	multiplier += Global.mult_sum

func collision():
	$AnimationPlayer.play("new_animation")
