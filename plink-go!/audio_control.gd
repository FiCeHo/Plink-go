extends HSlider

@export var audio_bus_name: String
var audioBusId

func _ready() -> void:
	audioBusId = AudioServer.get_bus_index(audio_bus_name)
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audioBusId, db)

func _on_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audioBusId, db)
