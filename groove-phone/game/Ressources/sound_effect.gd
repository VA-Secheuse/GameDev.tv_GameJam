extends Resource
class_name SoundEffect

enum SOUND_EFFECT_TYPE{
	ON_BUTTON_CLICKED,
	NOTIFICATION,
	ON_NOTE_CLICKED,
	PHONE_MESSAGE_RECEIVE
}

@export var type : SOUND_EFFECT_TYPE
@export var sound_effect : AudioStreamWAV
@export_range(-40,20) var volume = 0
