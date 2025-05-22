extends Resource
class_name PerkData

@export var id: String
@export var type := "perk"
@export var name: String
@export var description: String
@export var icon: Texture
@export var price: int = 0
@export_enum("common", "uncommon", "rare", "epic", "legendary") var rarity: String = "common"
