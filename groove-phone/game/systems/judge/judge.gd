class_name Judge extends Node

static var judge_scene_path = "res://game/systems/judge/Judge.tscn"

var composer : Composer

var in_beat = false
var action_valide = false
var rhythm_manager : RhythmManager
var metronome : Metronome

signal failure(beat : int,timing : String)
signal success(beat : int,timing : String)
##this is used by the text composer
signal input_validation(success: bool,type : String,beat_time : float)


func _beat_entered(beat : int):
	in_beat = true
	action_valide = false


func _beat_exited(beat : int):
	in_beat = false
	var button : String = composer.get_associated_beat_button(rhythm_manager.cur_beat)
	if !action_valide && button != "empty" :
		failure.emit(rhythm_manager.cur_beat,"missed")
		input_validation.emit(false,button,metronome.beat_duration_ms)
		

func _button_pressed(input_id : int):
	if action_valide:
		return
	var correct = false
	
	var button_row = composer.get_associated_row_button(rhythm_manager.cur_beat)
	var button = composer.get_associated_beat_button(rhythm_manager.cur_beat)
	if button == "empty":
		return
	match input_id :
		0: correct = button_row == 1.0
		1: correct = button_row == 2.0
		2: correct = button_row == 3.0
		3: correct = button_row == 4.0
		4:correct = button_row == 5.0
			
	if not correct:
		return
	if not in_beat :
		return
	var offset_ms = abs(metronome.time_since_beat_ms)  
	var timing: String
	if offset_ms < 50:
		timing = "perfect"
	elif offset_ms < 100:
		timing = "good"
	else:
		timing = "ok"
	action_valide = true
	success.emit(rhythm_manager.cur_beat,timing)
	input_validation.emit(true,button,metronome.beat_duration_ms)


func set_rhythm_manager(rhythm_manager : RhythmManager):
	self.rhythm_manager = rhythm_manager
func set_metronome(metronome : Metronome):
	self.metronome = metronome
func set_composer(composer : Composer):
	self.composer = composer
