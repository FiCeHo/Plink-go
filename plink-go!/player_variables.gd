extends Node

var ball_array = []
var perk_array = []
var money = 20

func _init():
	ball_array = Global.initial_ball_array

func has_perk(perk_id: String) -> bool:
	for perk in perk_array:
		if perk.id == perk_id:
			return true
	return false
