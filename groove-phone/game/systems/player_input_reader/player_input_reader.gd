class_name PlayerInputReader extends Node

signal input_pressed(input_id : int)

static var player_input_reader_path = "res://game/systems/player_input_reader/PlayerInputReader.tscn"

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("a_input")) :
		input_pressed.emit(0) 
	elif(Input.is_action_just_pressed("s_input")) :
		input_pressed.emit(1)
	elif(Input.is_action_just_pressed("k_input")) :
		input_pressed.emit(2)
	elif(Input.is_action_just_pressed("l_input")) :
		input_pressed.emit(3)
	elif(Input.is_action_just_pressed("space")) :
		input_pressed.emit(4)
	elif(Input.is_action_just_pressed("pause")):
		Global.pause_menu.open_pause_menu()
