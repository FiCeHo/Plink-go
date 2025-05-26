extends Resource
class_name BallData 

@export var id: String
@export var limit = 0
@export var value = 10
@export var bounce = 0.64
@export var gravity = 5
@export var texture : Texture
@export var price : int = 0

@export_enum("common", "uncommon", "rare", "epic", "legendary") var rarity: String = "common"
