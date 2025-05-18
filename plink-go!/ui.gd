extends CanvasLayer

var score = 0

func score_up(value):
	score += value
	$Score.text = str(score)
