extends Node

var ball_array = []
var perk_array = []
var money = 20
var current_score = 0
var current_round = 1

func _init():
	ball_array = Global.initial_ball_array
	
func new_game():
	ball_array = Global.initial_ball_array
	perk_array = []
	money = 5
	current_score = 0
	current_round = 1

func has_perk(perk_id: String) -> bool:
	for perk in perk_array:
		if perk.id == perk_id:
			return true
	return false
