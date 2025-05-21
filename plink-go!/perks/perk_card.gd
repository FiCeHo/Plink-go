extends Control
signal selected(perk_data: PerkData)

@export var perk_data: PerkData

func _ready():
	var box = StyleBoxFlat.new()
	box.bg_color = Color(1, 1, 0, 0.3)
	add_theme_stylebox_override("panel", box)

	if perk_data:
		$TextureRect.texture = perk_data.icon
	else:
		print("No perk_data!")

func update_display():
	$TextureRect.texture = perk_data.icon

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("selected", perk_data)
