extends Node2D

@export var multiplier : float

func _init() -> void:
	multiplier += Global.mult_sum
	
func _ready() -> void:
	if multiplier == 0:
		$StaticBody2D/Sprite2D.texture = load("res://x0.png")
	elif multiplier > 0 and multiplier <= 0.8:
		$StaticBody2D/Sprite2D.texture = load("res://x0.8.png")
	elif multiplier > 0.8 and multiplier <= 2:
		$StaticBody2D/Sprite2D.texture = load("res://x2.png")
	else:
		$StaticBody2D/Sprite2D.texture = load("res://x5.png")
	
	$StaticBody2D/Sprite2D.transform
