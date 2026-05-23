extends Node2D
class_name GameManager

@export var act_selection : ActSelection
@export var start_level_phone : StartLevelPhone

func _ready() -> void:
	self._create_and_connect_components()
	Global.sound_manager.play_main_menu_music()
	$RhythmManager.visible = false

func main_menu_to_act_selection() -> void:
	var cur_menu_pos = Global.main_menu.global_position
	Global.main_menu.pivot_offset = Global.main_menu.size / 2
	var correction = Vector2(-82, 459)

	var target_top_left = act_selection.left_corner.global_position


	var half_size = Global.main_menu.size / 2
	
	var rotated_offset = Vector2(half_size.y, half_size.x)

	var target_center = target_top_left + rotated_offset
	var target_pos = target_center - half_size + correction

	Global.main_menu.hide_menu_buttons()

	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(Global.main_menu, "global_position", target_pos, 0.5)
	tween.tween_property(Global.main_menu, "rotation_degrees", -90.0, 0.5)
	await tween.finished
	Global.main_menu.position = cur_menu_pos
	Global.main_menu.rotation_degrees = 0
	Global.main_menu.visible = false
	Global.main_menu.show_menu_buttons()
	$UI/ActSelectionMenu.visible = true

func _create_and_connect_components() -> void :
	##connect self to global script
	Global.game_manager = self
	##This create the sound manager and associate it the its global variable
	var tmp_scene : PackedScene = load(SoundManager.sound_manager_path)
	Global.sound_manager = tmp_scene.instantiate()
	add_child(Global.sound_manager)
	
	##this associate the settings to the global Variable
	Global.setting = $UI/Settings
	
	##this associate the main menu to the global Variable
	Global.main_menu = $UI/MainMenu
	
	##this associate the act selection the the global variable
	Global.act_selection = $UI/ActSelectionMenu
	
	##this associate the pause menu to the global variable
	Global.pause_menu = $UI/PauseMenu
	
	##this associate the RhythmManger to the global variable
	Global.current_rhythm_manager = $RhythmManager

func prep_first_act() -> void:
	var timer : Timer = Timer.new()
	timer.one_shot = true
	timer.autostart = false
	timer.wait_time = 1.5
	timer.timeout.connect(start_level_phone.first_act_start_animation)
	timer.timeout.connect(timer.queue_free)
	add_child(timer)
	start_level_phone.open()
	Global.sound_manager.stop_main_menu_music()
	timer.start()

func prep_second_act() -> void:
	var timer : Timer = Timer.new()
	timer.one_shot = true
	timer.autostart = false
	timer.wait_time = 1.5
	timer.timeout.connect(start_level_phone.second_act_start_animation)
	timer.timeout.connect(timer.queue_free)
	add_child(timer)
	start_level_phone.open()
	Global.sound_manager.stop_main_menu_music()
	timer.start()

func prep_third_act() -> void:
	var timer : Timer = Timer.new()
	timer.one_shot = true
	timer.autostart = false
	timer.wait_time = 1.5
	timer.timeout.connect(start_level_phone.third_act_start_animation)
	timer.timeout.connect(timer.queue_free)
	add_child(timer)
	start_level_phone.open()
	Global.sound_manager.stop_main_menu_music()
	timer.start()

func start_first_act() -> void:
	await $RhythmManager.load_level(load("res://game/Ressources/Track/act_2_track/act3_act.tres"))
	await start_level_phone.scale_to($RhythmManager.left_corner.global_position,Vector2(2.5,2.5),0.5)
	$RhythmManager.visible = true
	$RhythmManager.start_level()

func start_second_act() -> void:
	await $RhythmManager.load_level(load("res://game/Ressources/Track/act_2_track/act3_act.tres"))
	await start_level_phone.scale_to($RhythmManager.left_corner.global_position,Vector2(2.5,2.5),0.5)
	$RhythmManager.visible = true
	$RhythmManager.start_level()

func start_third_act() -> void:
	await $RhythmManager.load_level(load("res://game/Ressources/Track/act_2_track/act3_act.tres"))
	await start_level_phone.scale_to($RhythmManager.left_corner.global_position,Vector2(2.5,2.5),0.5)
	$RhythmManager.visible = true
	$RhythmManager.start_level()
