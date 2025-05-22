extends Control

signal selected(perk_data: PerkData, card_node: Control)

@export var perk_data: PerkData

func _ready():
	add_to_group("perk_card")
	update_display()
	set_mouse_filter(MOUSE_FILTER_STOP)
	connect("gui_input", _on_gui_input)

func update_display():
	if perk_data and perk_data.icon:
		$TextureRect.texture = perk_data.icon

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		print("Clicked:", perk_data.name)
		emit_signal("selected", perk_data, self)
