extends Node2D

var is_playing = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not is_playing:
		var audio_player = $AudioStreamPlayer
		if audio_player and not audio_player.playing:
			audio_player.play()
			is_playing = true


func _on_audio_stream_player_finished() -> void:
	is_playing = false
