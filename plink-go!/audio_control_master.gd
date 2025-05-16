extends HSlider

var audioBusM

func _ready() -> void:
	audioBusM = AudioServer.get_bus_index("Master")
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audioBusM, db)

func _on_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audioBusM, db)
