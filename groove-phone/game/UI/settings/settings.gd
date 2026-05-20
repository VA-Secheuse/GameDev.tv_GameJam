extends MarginContainer
class_name Settings

func _on_back_pressed() -> void:
	self.visible = false
	Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_BUTTON_CLICKED)

func open_setting_menu():
	$MarginContainer/Settings/VBoxContainer/VolumeSliders/VBoxContainer/MasterVolume.update_value()
	$MarginContainer/Settings/VBoxContainer/VolumeSliders/Music/Music.update_value()
	$MarginContainer/Settings/VBoxContainer/VolumeSliders/SFX/SFX.update_value()
	if Global.unlosable:
		$MarginContainer/Settings/VBoxContainer/UnlosableMode/Button.text = 'YES'
	else:
		$MarginContainer/Settings/VBoxContainer/UnlosableMode/Button.text = 'NO'
	self.visible = true


func _on_button_pressed() -> void:
	if Global.unlosable:
		$MarginContainer/Settings/VBoxContainer/UnlosableMode/Button.text = 'NO'
		Global.unlosable = false
	else:
		$MarginContainer/Settings/VBoxContainer/UnlosableMode/Button.text = 'YES'
		Global.unlosable = true
	Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_BUTTON_CLICKED)
