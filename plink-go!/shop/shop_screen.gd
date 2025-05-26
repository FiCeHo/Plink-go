extends Control

const ShowItem = preload("res://utils/show_item.gd")

var PlayerData = preload("res://player_variables.gd")

@onready var perk_list_display = get_node("ShopPanel/PerkPanel/MarginContainer/PerkShop")
@onready var details_panel = get_node("ShopPanel/ItemDetail")
@onready var name_label = get_node("ShopPanel/ItemDetail/NameLabel")
@onready var desc_label = get_node("ShopPanel/ItemDetail/DescriptionLabel")
@onready var buy_button = get_node("ShopPanel/BuyButton")
@onready var reroll_button = get_node("ShopPanel/RerollButton")
@onready var continue_button = get_node("ShopPanel/ContinueButton")
@onready var money_label = get_node("MoneyLabel")

@onready var perk_list = get_node("PlayerPerks")
@onready var sell_button = get_node("SellButton")

var ball_list
var ball_data_array = PlayerVariables.ball_array

@onready var ball_list_display = get_node("ShopPanel/BallPanel/MarginContainer/BallShop")


var reroll_cost = 5
var perk_amount = 3
var ball_amount = 4
var current_selected_item: Control = null
var current_selected_type: String = ""
var current_selected_data: Resource = null
var selected_from_shop := false

func _ready():
	PlayerVariables.current_score = 0
	_load_player_items("perk")
	_load_player_items("ball")
	
	_display_shop_items("perk")
	_display_shop_items("ball")
		
	buy_button.pressed.connect(_on_buy_button_pressed)
	sell_button.pressed.connect(_on_sell_button_pressed)
	reroll_button.text = "Reroll (%d $)" % reroll_cost
	reroll_button.pressed.connect(_on_reroll_button_pressed)
	continue_button.pressed.connect(_on_continue_button_pressed)
	_update_money_display()
	buy_button.hide()  # Hide by default
	details_panel.hide()
	sell_button.hide()
	$Panel2/AnimationPlayer.play("new_animation")
	
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
	desc_label.text = item_data.description

	var item_pos = item_node.get_global_position()
	var item_size = item_node.size
	var offset = Vector2(22, 0)
	
	var panel_size = details_panel.size
	var y_offset = (item_size.y - panel_size.y) / 2.0
	
	buy_button.hide()
	sell_button.hide()

	if selected_from_shop:
		buy_button.text = "Buy (%d $)" % item_data.price
		buy_button.size
		buy_button.size = buy_button.get_minimum_size()
		
		details_panel.global_position = item_pos + Vector2(item_size.x + offset.x, y_offset)

		var button_size = buy_button.size
		var x_center_offset = (item_size.x - button_size.x) / 2.0

		buy_button.global_position = item_pos + Vector2(x_center_offset, 76)
		buy_button.show()
	else:
		var sell_value = _get_sell_value(item_data)
		sell_button.text = "Sell (%d $)" % sell_value
		sell_button.size = sell_button.get_minimum_size()
		
		details_panel.global_position = item_pos - Vector2(panel_size.x + offset.x, -y_offset)

		var button_size = sell_button.size
		var x_center_offset = (item_size.x - button_size.x) / 2.0

		sell_button.global_position = item_pos + Vector2(x_center_offset, 76)
		sell_button.show()
			
	details_panel.show()

func _on_buy_button_pressed():
	if not current_selected_item:
		return
		
	if current_selected_type == "perk" && PlayerVariables.money >= current_selected_data.price:
		print("Bought perk:", current_selected_data.name)
		PlayerVariables.money -= current_selected_data.price
		_update_money_display()
		PlayerVariables.perk_array.append(current_selected_data)
			# Disable card
		current_selected_item.get_node("Holder").visible = false
		current_selected_item.mouse_filter = Control.MOUSE_FILTER_IGNORE

		details_panel.hide()
		buy_button.hide()
		current_selected_item = null
		current_selected_type = ""
		current_selected_data = null
		
		_load_player_items("perk")
		_load_player_items("ball")
	
	
func _on_sell_button_pressed():
	if current_selected_type == "perk" and current_selected_data:
		if PlayerVariables.perk_array.has(current_selected_data):
			var sell_value = _get_sell_value(current_selected_data)
			PlayerVariables.perk_array.erase(current_selected_data)
			PlayerVariables.money += sell_value
			_update_money_display()
			print("Sold:", current_selected_data.name)

	# Clean up
	current_selected_item.queue_free()
	current_selected_item = null
	current_selected_type = ""
	current_selected_data = null
	selected_from_shop = false

	details_panel.hide()
	sell_button.hide()

	_load_player_items("perk")
	_load_player_items("ball")

func _on_reroll_button_pressed():
	if PlayerVariables.money >= reroll_cost:
		PlayerVariables.money -= reroll_cost
		_update_money_display()
		reroll_cost += 2
		reroll_button.text = "Reroll (%d $)" % reroll_cost
		_do_reroll()
	else:
		print("Not enough money to reroll!")

func _on_continue_button_pressed():
	get_tree().change_scene_to_file("res://game/game.tscn")
	
func _do_reroll():
	for child in perk_list_display.get_children():
		child.queue_free()

	var all_perks = ItemUtils.get_all_perks()
	var perk_data_list
	if PlayerVariables.has_perk("havoc"):
		perk_data_list = ItemUtils.pick_weighted_items_havoc(
			all_perks,
			perk_amount,
			func(perk): return perk.rarity
		)
	else:
		perk_data_list = ItemUtils.pick_weighted_items(
			all_perks,
			perk_amount,
			func(perk): return perk.rarity
		)

	for perk_data in perk_data_list:
		var item = ShowItem.spawn(perk_data, "perk")
		item.set_meta("source", "shop")
		item.selected.connect(_on_item_selected)
		perk_list_display.add_child(item)

	print("Shop rerolled!")

func _update_money_display():
	money_label.text = "Money: %d $" % PlayerVariables.money

func _get_sell_value(item_data: Resource):
	var value = int(item_data.price * 0.5)
	if PlayerVariables.has_perk("haggler"):
		value = value * 2
	return value

func _display_shop_items(item_type: String):
	var container: Node
	var all_items: Array
	var picked_items: Array

	match item_type:
		"perk":
			container = perk_list_display
			all_items = ItemUtils.get_all_perks()
			if PlayerVariables.has_perk("havoc"):
				picked_items = ItemUtils.pick_weighted_items_havoc(all_items, perk_amount, func(p): return p.rarity)
			else:
				picked_items = ItemUtils.pick_weighted_items(all_items, perk_amount, func(p): return p.rarity)

		"ball":
			container = ball_list_display
			all_items = ItemUtils.get_all_balls()
			if PlayerVariables.has_perk("havoc"):
				picked_items = ItemUtils.pick_weighted_items_havoc(all_items, ball_amount, func(p): return p.rarity)
			else:
				picked_items = ItemUtils.pick_weighted_items(all_items, ball_amount, func(p): return p.rarity)
		_:
			return

	for child in container.get_children():
		child.queue_free()

	for item_data in picked_items:
		var item
		if item_data.type == "ball":
			item = ShowItem.spawn(item_data, item_type, true)
		else:
			item = ShowItem.spawn(item_data, item_type)
		item.set_meta("source", "shop")
		item.selected.connect(_on_item_selected)
		container.add_child(item)
		
func is_ball_holder(node):
	return node.name.contains("Ball_cont")

func _load_player_items(item_type: String):
	var container
	var items

	match item_type:
		"perk":
			container = perk_list
			items = PlayerVariables.perk_array
			for child in container.get_children():
				child.queue_free()

			for item_data in items:
				var item = ShowItem.spawn(item_data, item_type)
				item.set_meta("source", "player")
				item.selected.connect(_on_item_selected)
				item.get_node("Holder").self_modulate = Color.WHITE
				container.add_child(item)

		"ball":
			ball_list = $ShopUI.get_children().filter(is_ball_holder)
			var i = 0
			for ball_holder in ball_list:
				if i >= PlayerVariables.ball_array.size():
					break  # avoid index errors
					
				var ball_data = PlayerVariables.ball_array[i]
				var ball_card = ShowItem.spawn(ball_data, "ball", true)  # true = spawn card version
				
				if ball_card:
					ball_card.set_meta("source", "player")
					ball_card.selected.connect(_on_item_selected)
					ball_holder.add_child(ball_card)
			for holder in ball_list:
				for child in holder.get_children():
					child.queue_free()
			i += 1
		_:
			return
