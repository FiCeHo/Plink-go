extends Control

const ShowItem = preload("res://utils/show_item.gd")

var PlayerData = preload("res://player_variables.gd")

@onready var perk_list_display = get_node("ShopPanel/PerkPanel/MarginContainer/PerkShop")
@onready var details_panel = get_node("ShopPanel/ItemDetail")
@onready var name_label = get_node("ShopPanel/ItemDetail/NameLabel")
@onready var desc_label = get_node("ShopPanel/ItemDetail/DescriptionLabel")
@onready var buy_button = get_node("ShopPanel/BuyButton")

@onready var perk_list = get_node("PlayerPerks")
@onready var sell_button = get_node("SellButton")

var current_selected_item: Control = null
var current_selected_type: String = ""
var current_selected_data: Resource = null
var selected_from_shop := false

func _ready():
	load_player_perks()
	var all_perks = ItemUtils.get_all_perks()
	var perk_data_list = ItemUtils.pick_weighted_items(
		all_perks,
		2,
		func(perk): return perk.rarity
	)

	for perk_data in perk_data_list:
		var item = ShowItem.spawn(perk_data, "perk")
		item.set_meta("source", "shop")
		item.selected.connect(_on_item_selected)
		perk_list_display.add_child(item)
		print("Spawned item is a:", item.get_class())
		
	buy_button.pressed.connect(_on_buy_button_pressed)
	sell_button.pressed.connect(_on_sell_button_pressed)
	buy_button.hide()  # Hide by default
	details_panel.hide()
	sell_button.hide()
	
	print_tree_pretty()
		
func _on_item_selected(item_data: Resource, item_node: Control):
	# If the same item is clicked again, toggle it off
	if current_selected_item == item_node and details_panel.visible:
		details_panel.hide()
		buy_button.hide()
		sell_button.hide()
		current_selected_item = null
		current_selected_type = ""
		current_selected_data = null
		selected_from_shop = false
		return

	# Otherwise, update and show details
	current_selected_item = item_node
	current_selected_type = item_data.type
	current_selected_data = item_data
	selected_from_shop = item_node.get_meta("source") == "shop"

	name_label.text = item_data.name
	desc_label.text = "[font_size=12]%s[/font_size]" % item_data.description

	var item_pos = item_node.get_global_position()
	var item_size = item_node.size
	var offset = Vector2(16, 0)
	
	var panel_size = details_panel.size
	var y_offset = (item_size.y - panel_size.y) / 2.0
	
	details_panel.global_position = item_pos + Vector2(item_size.x + offset.x, y_offset)
	
	buy_button.hide()
	sell_button.hide()


	if selected_from_shop:
		buy_button.text = "Buy (%d $)" % item_data.price
		buy_button.size = buy_button.get_minimum_size()

		var button_size = buy_button.size
		var x_center_offset = (item_size.x - button_size.x) / 2.0

		buy_button.global_position = item_pos + Vector2(x_center_offset, 68)
		buy_button.show()
	else:
		sell_button.text = "Sell (%d $)" % int(item_data.price * 0.5)
		sell_button.size = sell_button.get_minimum_size()

		var button_size = sell_button.size
		var x_center_offset = (item_size.x - button_size.x) / 2.0

		sell_button.global_position = item_pos + Vector2(x_center_offset, 68)
		sell_button.show()
			
	details_panel.show()

func _on_buy_button_pressed():
	if not current_selected_item:
		return
		
	if current_selected_type == "perk":
		print("Bought perk:", current_selected_data.name)
		PlayerVariables.perk_array.append(current_selected_data)
	
	# Disable card
	current_selected_item.get_node("TextureRect").visible = false
	current_selected_item.mouse_filter = Control.MOUSE_FILTER_IGNORE

	details_panel.hide()
	buy_button.hide()
	current_selected_item = null
	current_selected_type = ""
	current_selected_data = null
	
	load_player_perks()
	
func _on_sell_button_pressed():
	if current_selected_type == "perk" and current_selected_data:
		if PlayerVariables.perk_array.has(current_selected_data):
			PlayerVariables.perk_array.erase(current_selected_data)
			print("Sold:", current_selected_data.name)

	# Clean up
	current_selected_item.queue_free()
	current_selected_item = null
	current_selected_type = ""
	current_selected_data = null
	selected_from_shop = false

	details_panel.hide()
	sell_button.hide()

	load_player_perks()
	
func load_player_perks():
	for child in perk_list.get_children():
		child.queue_free()
		
	for perk_data in PlayerVariables.perk_array:
		var item = ShowItem.spawn(perk_data, "perk")
		item.set_meta("source", "player")
		item.selected.connect(_on_item_selected)
		perk_list.add_child(item)
		print("Spawned item is a:", item.get_class())
