extends Control

signal selected(BallData: BallData, card_node: Control)

@export var ball_data: BallData

func _ready():
	add_to_group("ball_catd")
	update_display()
	set_mouse_filter(MOUSE_FILTER_STOP)
	connect("gui_input", _on_gui_input)

func update_display():
	if ball_data and ball_data.texture:
		$TextureRect.texture = ball_data.texture

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		print("Clicked:", ball_data.name)
		emit_signal("selected", ball_data, self)
