extends Label

var score = 0

func score_up(value):
	score += value
	text = str(score)
