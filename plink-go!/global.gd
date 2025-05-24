extends Node

var initial_position : Vector2
var void_multiplier = 10
var mult_sum = 0
var limit_sum = 0
var value_mult = 1

const initial_ball_array := [
	preload("res://balls/items/ball.tres"),
	preload("res://balls/items/ball.tres"),
	preload("res://balls/items/ball.tres"),
	preload("res://balls/items/ball.tres"),
	preload("res://balls/items/ball.tres"),
]
var initial_perk_array = []

var goals = [100, 500, 1000]
