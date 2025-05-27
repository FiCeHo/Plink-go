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

var perk_grav = 1
var perk_boost = 0
var perk_lifebuoy = false
var perk_stop = 1
var perk_mult = 1
var perk_reroll = 1
var perk_interest = 1
var perk_sell = 1
var perk_bounce = 0
var perk_rush = 0
var perk_magnet = false
var perk_jackpot = 1

func _init():
	ball_array = Global.initial_ball_array
	
func reset_perks():
	perk_grav = 1
	perk_boost = 0
	perk_lifebuoy = false
	perk_stop = 1
	perk_mult = 1
	perk_reroll = 1
	perk_interest = 1
	perk_sell = 1
	perk_bounce = 0
	perk_rush = 0
	perk_magnet = false
	perk_jackpot = 1
	
func new_game():
	ball_array = Global.initial_ball_array
	perk_array = []
	money = 5
	current_score = 0
	current_round = 1
	reset_perks()

func has_perk(perk_id: String) -> bool:
	for perk in perk_array:
		if perk.id == perk_id:
			return true
	return false
