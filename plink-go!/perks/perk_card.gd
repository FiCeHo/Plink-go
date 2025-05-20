extends Control
signal selected(perk_data: PerkData)

@export var perk_data: PerkData

func _ready():
	if perk_data:
		update_display()
	connect("gui_input", _on_gui_input)

func update_display():
	$TextureRect.texture = perk_data.icon

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("selected", perk_data)
