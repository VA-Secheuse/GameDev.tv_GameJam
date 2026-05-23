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

##variable for score
var ok : int = 50
var good : int = 75
var perfect : int = 100
var combo : int = 0
var score : int = 0

##variable for life
var max_life : int = 6
var life : int = 6
var cur_missed : int = 0
var cur_success : int = 0


signal beat_changed()
signal show_next_cue(interval : float, beat_info : Array)

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
	music_player.finished.connect(self._music_finished)
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
	cellphone.last_recipient_message_sent.connect(text_composer.next_player_word)
	add_child(text_composer)

##This change the music in the music player
func load_level(track : Track) -> void :
	await _create_and_associate_components()
	self.current_track = track
	music_player.set_music(track)
	metronome.set_track_bmp(track)
	composer.map_buttons(track)
	await text_composer.start_text_composer(track)

func start_level():
	self.visible = true
	metronome.start_metronome()
	music_player.start_track()
	var one_beat_before_start = self.when_is_next_input()[1] - metronome.beat_duration_ms
	text_composer.start_sentence_in(one_beat_before_start,true)

func _beat_changed(message : String, beat : int,travel_time : float):
	self.beat_changed.emit()
	self.cur_beat = beat
	if composer.get_associated_beat_info(cur_beat)['type'] == 'fin':
		metronome.stop_metronome()
	var beat_info : Dictionary = composer.get_associated_beat_info(cur_beat + 8)
	if beat_info == {}:
		return
	elif  beat_info['type'] == 'fin':
		return
	show_next_cue.emit(travel_time,beat_info)

##This function is called when a beat is succesfull
func _on_success(beat : int,timing : String):
	if !Global.unlosable:
		cur_success += 1
		if cur_success % 2 == 0:
			gain_life()
			cellphone.top_bar.gain_bar()
	_calculate_score(timing)
	cellphone.top_bar.set_score(score)
	cellphone.update_combo(combo)

##This calculate the score based on the timing of the input
func _calculate_score(timing : String):
	combo += 1
	if combo %10 == 0:
		Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_COMBO_UP_BIG)
	match timing :
		'ok':
			if Global.unlosable :
				score += (ok/2) * combo
			else :
				score += ok * combo
		'good':
			if Global.unlosable :
				score += (good/2) * combo
			else :
				score += good * combo
		'perfect':
			if Global.unlosable :
				score += (perfect/2) * combo
			else :
				score += perfect * combo

##This function is called when a beat is unsuccesfull
func _on_failure(beat : int,timing : String):
	if !Global.unlosable:
		Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_LIFE_LOST)
		cur_success = 0
		lose_life()
		cellphone.top_bar.lose_bar()
	combo = 0
	cellphone.update_combo(combo)

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

##this stop the metronome, clear the cue and stop the track
func stop_beat_game():
	music_player.stop_track()
	cellphone.clear_cues()
	metronome.stop_metronome()

func restart_level():
	await exit_level()
	await load_level(current_track)
	await start_level()

func lose_life():
	life -= 1
	if life <= 0:
		lose_level()

func gain_life():
	if life >= max_life:
		return
	life += 1

func exit_level():
	cur_beat = 0
	combo = 0
	time_position_ms = 0.0
	life = max_life
	cur_missed = 0
	cur_success = 0
	self.visible = false
	if show_next_cue.is_connected(cellphone._show_next_cue):
		show_next_cue.disconnect(cellphone._show_next_cue)
	if judge.failure.is_connected(cellphone._on_failure):
		judge.failure.disconnect(cellphone._on_failure)
	if judge.success.is_connected(cellphone._on_success):
		judge.success.disconnect(cellphone._on_success) 
	music_player.stop_track()
	player_input_reader.queue_free()
	music_player.queue_free()
	metronome.queue_free() 
	composer.queue_free()
	judge.queue_free()
	cellphone.queue_free() 
	text_composer.queue_free() 
	
func lose_level():
	stop_beat_game()
	var act_score = Global.score_dic[current_track.act] 
	var highest : bool = false
	if score > act_score:
		highest = true
		Global.score_dic[current_track.act] = score
	cellphone.show_lose_menu(score,highest)

func level_success():
	stop_beat_game()
	Global.UNLOCK_NEXT_ACT()
	var act_score = Global.score_dic[current_track.act] 
	var highest : bool = false
	if score > act_score:
		highest = true
		Global.score_dic[current_track.act] = score
	cellphone.show_success_menu(score,highest)

func _music_finished():
	level_success()
