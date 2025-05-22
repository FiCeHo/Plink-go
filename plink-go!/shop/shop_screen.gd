extends Control

const ItemUtils = preload("res://utils/item_utils.gd")
const ShowItem = preload("res://utils/show_item.gd")

@onready var perk_list_display = get_node("ShopPanel/PerkPanel/MarginContainer/PerkShop")
@onready var details_panel = get_node("ShopPanel/PerkPanel/PerkDetail")
@onready var name_label = get_node("ShopPanel/PerkPanel/PerkDetail/NameLabel")
@onready var desc_label = get_node("ShopPanel/PerkPanel/PerkDetail/DescriptionLabel")

func _ready():
	details_panel.hide()
	var all_perks = ItemUtils.get_all_perks()
	var perk_data_list = ItemUtils.pick_weighted_items(
		all_perks,
		2,
		func(perk): return perk.rarity
	)

	for perk_data in perk_data_list:
		print(perk_data.icon)
		var item = ShowItem.spawn(perk_data, "perk")
		item.selected.connect(_on_perk_selected)
		perk_list_display.add_child(item)
		print("Spawned card is a:", item.get_class())
	print_tree_pretty()
		
func _on_perk_selected(perk: PerkData, card_node: Control):
	print("Perk selected:", perk.name)
	# Update the text
	name_label.text = perk.name
	desc_label.text = perk.description

	# Position the details panel next to the selected card
	var card_pos = card_node.get_global_position()
	var card_size = card_node.size
	var offset = Vector2(16, 0)  # Pixels to the right

	details_panel.global_position = card_pos + Vector2(card_size.x, 0) + offset
	details_panel.show()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		# Check what was under the mouse
		var mouse_pos = get_viewport().get_mouse_position()
		var clicked = get_viewport().gui_pick(mouse_pos)

		# If we didn't click a PerkCard or the DetailsPanel itself
		if !clicked or not clicked.is_in_group("perk_card") and clicked != details_panel:
			print("Clicked outside — hiding detail panel.")
			details_panel.hide()
