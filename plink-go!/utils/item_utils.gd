extends Node
class_name ItemUtils

## 🔢 Default rarity weights (can be overridden)
static var default_rarity_weights := {
	"common": 40,
	"uncommon": 30,
	"rare": 20,
	"epic": 7,
	"legendary": 3
}

# 🔄 Load all .tres resources from a given folder
static func load_items_from_folder(folder_path: String) -> Array:
	var dir = DirAccess.open(folder_path)
	var items: Array = []

	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var item = load(folder_path + "/" + file_name)
				if item:
					items.append(item)
			file_name = dir.get_next()
		dir.list_dir_end()
	
	return items

# 🟠 Load all perks
static func get_all_perks() -> Array:
	return load_items_from_folder("res://perks/items")

# 🔵 Load all balls
static func get_all_balls() -> Array:
	return load_items_from_folder("res://balls/items")

# 🟡 Load all modifiers
static func get_all_modifiers() -> Array:
	return load_items_from_folder("res://modifiers/items")


## 🎲 Pick N weighted items from a pool based on rarity
static func pick_weighted_items(
	pool: Array,
	count: int,
	get_rarity_func: Callable,
	rarity_weights := default_rarity_weights
) -> Array:
	var selected: Array = []
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	while selected.size() < count and pool.size() > 0:
		var remaining_pool = pool.filter(func(item): return not selected.has(item))
		var weighted_pool: Array[Dictionary] = []

		for item in remaining_pool:
			var rarity = get_rarity_func.call(item)
			var weight = rarity_weights.get(rarity, 1)
			weighted_pool.append({ "item": item, "weight": weight })

		var total_weight = 0
		for entry in weighted_pool:
			total_weight += entry.weight
		var choice = rng.randi_range(1, total_weight)
		var running_total = 0

		for entry in weighted_pool:
			running_total += entry.weight
			if choice <= running_total:
				selected.append(entry.item)
				break

	return selected

# Group items by rarity
static func group_by_rarity(pool: Array, get_rarity_func: Callable) -> Dictionary:
	var result := {}
	for item in pool:
		var rarity = get_rarity_func.call(item)
		if not result.has(rarity):
			result[rarity] = []
		result[rarity].append(item)
	return result
	
# Pick N completely random items
static func pick_unweighted_items(pool: Array, count: int) -> Array:
	var shuffled = pool.duplicate()
	shuffled.shuffle()
	return shuffled.slice(0, count)
	
