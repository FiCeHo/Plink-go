extends Node2D

var multiplier : float

func collision():
	$AnimationPlayer.play("new_animation")
