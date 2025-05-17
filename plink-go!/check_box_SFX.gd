extends CheckBox


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		var audioBusId = AudioServer.get_bus_index("SFX")
		var db = linear_to_db(0)
		AudioServer.set_bus_volume_db(audioBusId, db)
	else:
		var audioBusId = AudioServer.get_bus_index("SFX")
		var db = linear_to_db(0.5)
		AudioServer.set_bus_volume_db(audioBusId, db)
