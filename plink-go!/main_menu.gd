extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options

func _ready() -> void:
	main_buttons.visible = true
	options.visible = false

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://game/game.tscn")


func _on_options_pressed() -> void:
	main_buttons.visible = false
	options.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_opts_pressed() -> void:
	_ready();
