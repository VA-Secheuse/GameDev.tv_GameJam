class_name RhythmManager extends Node2D

@export var left_corner : Marker2D

var current_track : Track

var player_input_reader : PlayerInputReader
var music_player : MusicPlayer
var metronome : Metronome
var composer : Composer
var judge : Judge
var cellphone : CellPhone
var text_composer : TextComposer

var time_position_ms : float
var cur_beat : int = 0

signal beat_changed()
signal tmp_signal()
signal tmp_2(message)

signal show_next_cue(interval : float, beat_info : Array)

func _init() -> void:
	self._create_and_associate_components()


func _create_and_associate_components() -> void :
	var tmp_scene : PackedScene
	
	##This create and connect PlayerInputReader and its signals
	tmp_scene = load(PlayerInputReader.player_input_reader_path)
	player_input_reader = tmp_scene.instantiate()
	add_child(player_input_reader)
	
	##This create and connect MusicPlayer and its signals
	tmp_scene = load(MusicPlayer.music_player_scene_path)
	music_player = tmp_scene.instantiate()
	music_player.set_rhythm_manager(self)
	add_child(music_player)
	
	##This create and connect Metronome and its signals
	tmp_scene = load(Metronome.metronome_scene_path)
	metronome = tmp_scene.instantiate()
	metronome.set_rhythm_manager(self)
	metronome.beat_changed.connect(_beat_changed)
	add_child(metronome)
	
	##This create and connect Composer and its signals
	tmp_scene = load(Composer.composer_scene_path)
	composer = tmp_scene.instantiate()
	add_child(composer)
	
	##This create and connect Judge and its signals
	tmp_scene = load(Judge.judge_scene_path)
	judge = tmp_scene.instantiate()
	player_input_reader.input_pressed.connect(judge._button_pressed)
	metronome.exit_beat.connect(judge._beat_exited)
	metronome.enter_beat.connect(judge._beat_entered)
	judge.set_composer(self.composer)
	judge.set_metronome(self.metronome)
	judge.set_rhythm_manager(self)
	judge.failure.connect(_on_failure)
	judge.success.connect(_on_success)
	add_child(judge)
	
	##This create and connect the display
	tmp_scene = load(CellPhone.cellphone_scene_path)
	cellphone = tmp_scene.instantiate()
	cellphone.set_rhythm_manager(self)
	judge.failure.connect(cellphone._on_failure)
	judge.success.connect(cellphone._on_success)
	show_next_cue.connect(cellphone._show_next_cue)
	add_child(cellphone)
	
	##This create and connect the TextComposer
	tmp_scene = load(TextComposer.text_composer_scene_path)
	text_composer = tmp_scene.instantiate()
	text_composer.set_rhythm_manager(self)
	text_composer.set_cellphone(cellphone)
	judge.input_validation.connect(text_composer.input_pressed_and_checked)
	add_child(text_composer)

##This change the music in the music player
func change_music(track : Track) -> void :
	self.current_track = track
	music_player.set_music(track)
	metronome.set_track_bmp(track)
	composer.map_buttons(track)
	text_composer.start_text_composer(track)

func start_level():
	metronome.start_metronome()
	music_player.start_track()
	var one_beat_before_start = self.when_is_next_input()[1] - metronome.beat_duration_ms
	text_composer.start_sentence_in(one_beat_before_start,true)

func _beat_changed(message : String, beat : int,travel_time : float):
	self.beat_changed.emit()
	self.cur_beat = beat
	if composer.get_associated_beat_info(cur_beat)['type'] == 'fin':
		stop_beat_game()
	var beat_info : Dictionary = composer.get_associated_beat_info(cur_beat + 8)
	if beat_info == {}:
		return
	elif  beat_info['type'] == 'fin':
		return
	show_next_cue.emit(travel_time,beat_info)

func _on_success():
	tmp_2.emit("success")

func _on_failure():
	tmp_2.emit("failure")

func get_time_position_ms() -> float :
	return time_position_ms

##this function give the upcomming color in x from the current beat
func get_beat_button_in(space : int):
	return composer.get_associated_beat_button(cur_beat + space)

##this return in how much time in ms the next beat is comming and its type
func when_is_next_input() -> Array:
	var cur_input_location : int = 1
	var beat_type : String = ""

	while true :
		beat_type = self.get_beat_button_in(cur_input_location)
		if beat_type != 'empty' and beat_type != null:
			break 
		cur_input_location +=1
		if cur_input_location > 100:  # safety cap
			return ["empty", 0.0]
	
	var target_beat = cur_beat + cur_input_location
	var target_beat_ms = target_beat * metronome.beat_duration_ms
	
	var next_input_ms : float = target_beat_ms - self.get_time_position_ms()
	
	return[beat_type,next_input_ms]

##this stop the metronome
func stop_beat_game():
	metronome.stop_metronome()
