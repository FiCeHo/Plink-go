extends CanvasLayer

var score = 0

func score_up():
	score += 1
	$Score.text = str(score)


func _on_button_pressed() -> void:
	score_up()
