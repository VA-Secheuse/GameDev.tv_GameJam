class_name MusicPlayer extends AudioStreamPlayer

static var music_player_scene_path = "res://game/systems/music_player/MusicPlayer.tscn"

var rhythm_manager : RhythmManager



func _process(delta: float) -> void:
	if self.playing :
		rhythm_manager.time_position_ms = self.get_playback_position() * 1000

func set_music(track : Track):
	self.autoplay = false
	self.stream = track.audio_stream

func start_track() :
	self.play()

func stop_track():
	self.stop()

func set_rhythm_manager(rhythm_manager : RhythmManager) -> void:
	self.rhythm_manager = rhythm_manager
