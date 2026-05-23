extends MarginContainer
class_name MainMenu

signal play_pressed
signal how_to_play_pressed
signal settings_pressed
signal exit_pressed

@export var left_corner : Marker2D

func _on_play_pressed() -> void:
	await flip_to(Global.act_selection.left_corner.global_position,-90.0)
	Global.act_selection.show_menu()

func _on_how_to_play_pressed() -> void:
	how_to_play_pressed.emit()

func hide_menu_buttons() -> void:
	$Panel/MenuButton.visible = false

func show_menu_buttons() -> void:
	$Panel/MenuButton.visible = true

func _on_settings_pressed() -> void:
	Global.setting.open_setting_menu()

func _on_exit_pressed() -> void:
	Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_BUTTON_CLICKED)
	get_tree().quit()

func open():
	self.visible = true
	Global.sound_manager.play_main_menu_music()

func flip_to(target_top_left: Vector2, target_rotation_deg: float) -> void:
	var cur_menu_pos = self.global_position
	var cur_deg = self.rotation_degrees
	
	pivot_offset = size / 2
	var half_size = size / 2
	var rad = deg_to_rad(target_rotation_deg)
	
	var corner_offset = Vector2(-half_size.x, -half_size.y)
	var rotated_corner = Vector2(
		corner_offset.x * cos(rad) - corner_offset.y * sin(rad),
		corner_offset.x * sin(rad) + corner_offset.y * cos(rad)
	)
	
	var target_center = target_top_left - rotated_corner
	var target_pos = target_center - half_size + Vector2(-82, 1058.9)
	
	# Print what the math thinks vs the marker

	
	hide_menu_buttons()
	
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", target_pos, 0.5)
	tween.tween_property(self, "rotation_degrees", target_rotation_deg, 0.5)
	await tween.finished
	self.position = cur_menu_pos
	self.rotation_degrees = cur_deg
	self.visible = false
	show_menu_buttons()
	
