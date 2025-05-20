extends Node
class_name ShowItem

static func spawn(item_data: Resource, item_type: String) -> Node:
	var base_path = ""

	match item_type:
		"perk":
			base_path = "res://scenes/perks/item/"
		"ball":
			base_path = "res://scenes/balls/item/"
		"modifier":
			base_path = "res://scenes/modifiers/items/"
		_:
			push_error("Unknown item type: %s" % item_type)
			return null
	
	var scene_path = base_path + item_data.id + ".tscn"

	if ResourceLoader.exists(scene_path):
		var scene = load(scene_path)
		if scene is PackedScene:
			var item = scene.instantiate()

			# Assign item data to a generic or type-specific variable
			if item.has_variable("item_data"):
				item.item_data = item_data
			elif item.has_variable(item_type + "_data"):
				item.set(item_type + "_data", item_data)
			else:
				push_warning("Item scene has no recognized data variable!")

			return item
		else:
			push_error("Scene is not a PackedScene: %s" % scene_path)
	else:
		push_error("Missing item scene: %s" % scene_path)

	return null
