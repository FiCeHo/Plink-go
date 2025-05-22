extends Node

var ball_array
var perk_array = []
var current_score = 0
var current_round = 1

func _init():
	ball_array = Global.initial_ball_array
