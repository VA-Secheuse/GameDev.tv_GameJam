extends Button
class_name PhoneButton

enum BUTTON_TYPE{
	NORMAL,
	BACK
}

@export var type: BUTTON_TYPE = BUTTON_TYPE.NORMAL

func _ready() -> void:
	self.pressed.connect(self._pressed)
	self.mouse_entered.connect(self._hovered)

func _pressed():
	match type:
		BUTTON_TYPE.NORMAL:
			Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_OPEN_PHONEMENU)
		BUTTON_TYPE.BACK:
			Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_SELECT_PHONEMENU)

func _hovered():
	Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_MOUSEHOVER_PHONEMENU)
