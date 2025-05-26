extends Resource
class_name BallData 

@export var id : String = "ball"
@export var type : String = "ball"
@export var custom : bool = false
@export var limit = 0
@export var value = 10
@export var mult = 1
@export var bounce = 0.64
@export var gravity : float = 5
@export var texture : Texture
@export var price : int = 0

@export_enum("common", "uncommon", "rare", "epic", "legendary") var rarity: String = "common"
