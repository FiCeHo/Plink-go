extends Control

const ItemUtils = preload("res://utils/item_utils.gd")
const ShowItem = preload("res://utils/show_item.gd")

@onready var perk_list_display = get_node("ShopPanel/PerkPanel/MarginContainer/PerkShop")
@onready var details_panel = get_node("ShopPanel/PerkPanel/PerkDetail")
@onready var name_label = get_node("ShopPanel/PerkPanel/PerkDetail/NameLabel")
@onready var desc_label = get_node("ShopPanel/PerkPanel/PerkDetail/DescriptionLabel")

func _ready():
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
	print_tree_pretty()
		
func _on_perk_selected(perk: PerkData, card_node: Control):
	# Update the details content
	name_label.text = perk.name
	desc_label.text = perk.description

	# Position the popup near the card
	var card_global_pos = card_node.get_global_position()
	var panel_size = details_panel.size
	var offset = Vector2(10, 0)  # 10 pixels to the right

	details_panel.global_position = card_global_pos + Vector2(card_node.size.x, 0) + offset
	details_panel.show()
	

	
