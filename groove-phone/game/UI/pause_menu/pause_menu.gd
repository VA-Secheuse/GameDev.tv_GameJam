extends MarginContainer
class_name PauseMenu


func open_pause_menu():
	self.visible = true
	Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.UI_OPEN_PAUSEMENU)
	Global.current_rhythm_manager.process_mode = Node.PROCESS_MODE_DISABLED
	

func _on_continue_pressed() -> void:
	exit()


func _on_settings_pressed() -> void:
	Global.setting.open_setting_menu()


func _on_main_menu_pressed() -> void:
	exit()
	Global.current_rhythm_manager.exit_level()
	Global.main_menu.open()
 


func _on_restart_pressed() -> void:
	await Global.current_rhythm_manager.restart_level()
	exit()

func exit():
	Global.current_rhythm_manager.process_mode = Node.PROCESS_MODE_ALWAYS
	self.visible = false
	
