class_name Composer extends Node
 
var button_array : Array

static var composer_scene_path : String = "res://game/systems/composer/Composer.tscn"

func map_buttons(track : Track):
	button_array = JsonFormating.input_mapping_to_array(track)

func get_associated_row_button(beat : int):
	if button_array.size() >= beat:
		return button_array[beat - 1]["row"]
	return null

func get_associated_beat_button(beat : int):
	if button_array.size() >= beat:
		return button_array[beat - 1]["type"]
	return ""

func get_associated_beat_info(beat : int):
	if button_array.size() >= beat:
		return button_array[beat-1]
	return {}
