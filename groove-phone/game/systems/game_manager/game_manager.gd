extends Node2D


func _ready() -> void:
	await self._create_and_connect_components()
	Global.sound_manager.play_main_menu_music()
	$RhythmManager.visible = false

func _create_and_connect_components() -> void :
	
	##This create the sound manager and associate it the its global variable
	var tmp_scene : PackedScene = load(SoundManager.sound_manager_path)
	Global.sound_manager = tmp_scene.instantiate()
	add_child(Global.sound_manager)
	
	##this associate the settings to the global Variable
	Global.setting = $Settings
	
	##this associate the main menu to the global Variable
	Global.main_menu = $MainMenu
