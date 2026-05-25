class_name Metronome extends Node

static var metronome_scene_path = "res://game/systems/metronome/Metronome.tscn"

var track_bmp : int
var beat_duration_ms : float
var last_beat : int
var next_beat_position : float
var active_beat : int = -1
var window_beat : int = -1
var margin_ms : int = 200
var active_beat_start_position : float
var active_beat_end_position : float
var enter_emitted : bool = false
var travel_time_sec : float
var is_metronome_active : bool = false

var time_since_beat_ms: float = 0.0

var rhythm_manager : RhythmManager

signal beat_changed(info : String, lastBeat : int,travel_time : float)
signal enter_beat(beat : int)
signal exit_beat(beat : int)


func set_track_bmp(track : Track) -> void :
	self.track_bmp = track.bmp
	self.beat_duration_ms = (60.0 / self.track_bmp) * 1000.0
	self.margin_ms = track.margin
	self.last_beat = 0 
	self.travel_time_sec = (beat_duration_ms * 8.0) /1000.0 
	self.next_beat_position = beat_duration_ms
	self.active_beat_start_position = self.next_beat_position - self.margin_ms  
	self.active_beat_end_position = self.next_beat_position + self.margin_ms 
	self.enter_emitted = false

func set_rhythm_manager(Rhythm_manager : RhythmManager):
	self.rhythm_manager = Rhythm_manager

func _process(delta: float) -> void:
	if is_metronome_active :
		time_since_beat_ms += delta * 1000.0
		calculate_beat()

func start_metronome():
	is_metronome_active = true

func stop_metronome():
	is_metronome_active = false

 ##This is the core logic of the metronome

func calculate_beat():
		
	var position = rhythm_manager.get_time_position_ms()
	
	var current_beat = int(position / beat_duration_ms) + 1
	
	if current_beat != last_beat:
		if window_beat != -1 and not enter_emitted == false:
			exit_beat.emit(window_beat)
		
		last_beat = current_beat
		next_beat_position = current_beat * beat_duration_ms
		active_beat = current_beat
		window_beat = current_beat
		active_beat_start_position = next_beat_position - margin_ms * 2
		active_beat_end_position   = next_beat_position + margin_ms
		enter_emitted = false
		time_since_beat_ms = 0.0
		beat_changed.emit("beat", current_beat, self.travel_time_sec)

	# Enter Window
	if window_beat != -1 and position >= active_beat_start_position and position <= active_beat_end_position:
		if not enter_emitted:
			enter_beat.emit(window_beat)
			enter_emitted = true
	# Exit Window
	if window_beat != -1 and position > active_beat_end_position:
		exit_beat.emit(window_beat)
		window_beat = -1
		enter_emitted = false

func time_since_beat() :
	return time_since_beat
