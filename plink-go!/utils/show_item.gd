extends Node
class_name ShowItem

static func spawn(item_data: Resource, item_type: String, as_card := false) -> Node:
	var base_path = ""

	match item_type:
		"perk":
			base_path = "res://perks/"
		"ball":
			base_path = "res://balls/"
		"modifier":
			base_path = "res://modifiers/"
		_:
			push_error("Unknown item type: %s" % item_type)
			return null
			
	var suffix
	if as_card:
		suffix = "_scene_card.tscn"
	else:
		suffix = "_scene.tscn"
	var scene_path = base_path + item_type + suffix

	if ResourceLoader.exists(scene_path):
		var scene = load(scene_path)
		if scene is PackedScene:
			var item = scene.instantiate()
			if suffix.ends_with("_card.tscn"):
				var a
			elif item_type == "ball":
				if item_data.custom:
					var col_scene = load("res://balls/collisions/collision_" + item_data.id + ".tscn")
					var collision = col_scene.instantiate()
					item.get_node("RigidBody2D").get_node("CollisionShape2D").queue_free()
					item.get_node("RigidBody2D").add_child(collision)
					if item_data.id == "beachball" || item_data.id == "gumball":
						item.get_node("RigidBody2D/Sprite2D").scale = Vector2(1.0, 1.0)

			# Assign data to correct property
			if item.has_method("set"):
				match item_type:
					"perk":
						if "perk_data" in item:
							item.perk_data = item_data
					"ball":
						if "ball_data" in item:
							item.ball_data = item_data
					"modifier":
						if "modifier_data" in item:
							item.modifier_data = item_data

			# Mark its type for reference
			item.set_meta("item_type", item_type)
			item.set_meta("is_card", as_card)
			return item
	else:
		push_error("Missing item scene: %s" % scene_path)
		return null
	return null
