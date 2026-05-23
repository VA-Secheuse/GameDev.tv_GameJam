extends Button
class_name SettingButton

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
			Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_SELECT_PAUSEMENU)
		BUTTON_TYPE.BACK:
			Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_CLOSE_PAUSEMENU)

func _hovered():
	Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_MOUSEHOVER_PAUSEMENU)
