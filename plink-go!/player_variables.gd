extends Node

signal update_score(score)

var ball_array = []
var perk_array = []
var money = 200000000
var current_score = 0:
	set(value):
		current_score = value
		emit_signal("update_score")
var current_round = 1

var perk_grav = false
var perk_boost = false
var perk_lifebouy = false
var perk_stop = false
var perk_mult = false
var perk_reroll = false
var perk_interest = false
var perk_sell = false
var perk_bounce = false
var perk_rush = false
var perk_magnet = false
var perk_jackpot = false

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
