extends CanvasLayer

var score = 0

func score_up(value):
	score += roundf(value)
	$Score.text = "Score: " + str(score)
