extends MarginContainer
class_name MainMenu

signal play_pressed
signal how_to_play_pressed
signal settings_pressed
signal exit_pressed


func _on_play_pressed() -> void:
	Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_BUTTON_CLICKED)
	play_pressed.emit()

func _on_how_to_play_pressed() -> void:
	Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_BUTTON_CLICKED)
	how_to_play_pressed.emit()


func _on_settings_pressed() -> void:
	Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_BUTTON_CLICKED)
	Global.setting.open_setting_menu()


func _on_exit_pressed() -> void:
	Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_BUTTON_CLICKED)
	get_tree().quit()
