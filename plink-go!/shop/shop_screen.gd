extends Control

const ItemUtils = preload("res://utils/item_utils.gd")
const ShowItem = preload("res://utils/show_item.gd")

var PlayerData = preload("res://player_variables.gd")

@onready var perk_list_display = get_node("ShopPanel/PerkPanel/MarginContainer/PerkShop")
@onready var details_panel = get_node("ShopPanel/ItemDetail")
@onready var name_label = get_node("ShopPanel/ItemDetail/NameLabel")
@onready var desc_label = get_node("ShopPanel/ItemDetail/DescriptionLabel")
@onready var buy_button = get_node("ShopPanel/BuyButton")
var current_selected_item: Control = null
var current_selected_type: String = ""
var current_selected_data: Resource = null

func _ready():
	details_panel.hide()
	var all_perks = ItemUtils.get_all_perks()
	var perk_data_list = ItemUtils.pick_weighted_items(
		all_perks,
		2,
		func(perk): return perk.rarity
	)

	for perk_data in perk_data_list:
		var item = ShowItem.spawn(perk_data, "perk")
		item.selected.connect(_on_item_selected)
		perk_list_display.add_child(item)
		print("Spawned item is a:", item.get_class())
		
	buy_button.pressed.connect(_on_buy_button_pressed)
	buy_button.hide()  # Hide by default
	print_tree_pretty()
		
func _on_item_selected(item_data: Resource, item_node: Control):
	# If the same item is clicked again, toggle it off
	if current_selected_item == item_node and details_panel.visible:
		details_panel.hide()
		buy_button.hide()
		current_selected_item = null
		current_selected_type = ""
		current_selected_data = null
		return

	# Otherwise, update and show details
	current_selected_item = item_node
	current_selected_type = item_data.type
	current_selected_data = item_data

	name_label.text = item_data.name
	desc_label.text = "[font_size=12]%s[/font_size]" % item_data.description

	var item_pos = item_node.get_global_position()
	var item_size = item_node.size
	var offset = Vector2(16, 0)
	
	var panel_size = details_panel.size
	var y_offset = (item_size.y - panel_size.y) / 2.0
	
	details_panel.global_position = item_pos + Vector2(item_size.x + offset.x, y_offset)
	buy_button.global_position = item_pos + Vector2(-5,  68)
	buy_button.text = "Buy (%d $)" % item_data.price

	details_panel.show()
	buy_button.show()

func _on_buy_button_pressed():

	details_panel.hide()
	buy_button.hide()
	current_selected_item = null
