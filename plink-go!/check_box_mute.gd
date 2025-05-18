extends CheckBox

@export var audio_bus_name: String
var audioBusId;

func _ready() -> void:
	audioBusId = AudioServer.get_bus_index(audio_bus_name)

func _on_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(audioBusId, toggled_on)
