extends Resource
class_name SoundEffect

enum SOUND_EFFECT_TYPE{
	ON_BUTTON_CLICKED,
	NOTIFICATION,
	ON_NOTE_CLICKED
}

@export var type : SOUND_EFFECT_TYPE
@export var sound_effect : AudioStreamMP3
@export_range(-40,20) var volume = 0
