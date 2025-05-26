extends Node
class_name ShowItem

static func spawn(item_data: Resource, item_type: String) -> Node:
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
	
	var scene_path = base_path + item_type + "_scene.tscn"

	if ResourceLoader.exists(scene_path):
		var scene = load(scene_path)
		if scene is PackedScene:
			var item = scene.instantiate()
			item.set(item_type + "_data", item_data)
			if item_type == "ball":
				if item_data.custom:
					var col_scene = load("res://balls/collisions/collision_" + item_data.ID + ".tscn")
					var collision = col_scene.instantiate()
					item.get_node("RigidBody2D").get_node("CollisionShape2D").queue_free()
					item.get_node("RigidBody2D").add_child(collision)
					if item_data.ID == "beachball" || item_data.ID == "gumball":
						item.get_node("RigidBody2D/Sprite2D").scale = Vector2(1.0, 1.0)
			return item
		else:
			push_error("Scene is not a PackedScene: %s" % scene_path)
	else:
		push_error("Missing item scene: %s" % scene_path)

	return null
