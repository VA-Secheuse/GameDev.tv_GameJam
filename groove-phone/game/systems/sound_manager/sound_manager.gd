class_name SoundManager 
extends Node2D

var sound_effect_dict : Dictionary = {}
static var sound_manager_path : String = "res://game/systems/sound_manager/SoundManager.tscn"
@export var sound_effects : Array[SoundEffect]

@export var main_menu_music : AudioStreamMP3

var main_menu_audio_stream : AudioStreamPlayer

func _ready() -> void:
	for sound_effect in sound_effects:
		sound_effect_dict[sound_effect.type] = sound_effect
	main_menu_audio_stream = $AudioStreamPlayer
	main_menu_audio_stream.stream = main_menu_music
	main_menu_audio_stream.stream.loop = true

func create_audio(type: SoundEffect.SOUND_EFFECT_TYPE) -> void:
	if sound_effect_dict.has(type):
		var sound_effect : SoundEffect = sound_effect_dict[type]
		var new_audio : AudioStreamPlayer = AudioStreamPlayer.new()
		new_audio.bus = &'sfx'
		add_child(new_audio)
		new_audio.stream = sound_effect.sound_effect
		new_audio.volume_db = sound_effect.volume
		new_audio.finished.connect(new_audio.queue_free)
		print("playing: ", sound_effect.sound_effect, " volume: ", sound_effect.volume, " bus: ", new_audio.bus)
		new_audio.play()
	else  :
		push_error('Sound Manager Failed to find setting for type ', type)

func play_main_menu_music() -> void:
	main_menu_audio_stream.play()

func stop_main_menu_music() -> void:
	main_menu_audio_stream.stop()
