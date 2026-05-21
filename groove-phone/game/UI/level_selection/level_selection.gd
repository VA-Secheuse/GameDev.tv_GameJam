extends TextureRect
class_name ActSelection

@export var left_corner : Marker2D


func show_menu() :
	self.visible = true

func hide_menu() :
	self.visible = false

func flip_to(target_top_left: Vector2, target_rotation_deg: float) -> void:
	var cur_menu_pos = self.global_position
	var cur_deg = self.rotation_degrees

	# Set pivot to center WITHOUT causing a visual jump
	var old_pivot = pivot_offset
	pivot_offset = size / 2
	global_position += (pivot_offset - old_pivot)

	var half_size = size / 2
	var rad = deg_to_rad(target_rotation_deg)

	var corner_offset = Vector2(-half_size.x, -half_size.y)
	var rotated_corner = Vector2(
		corner_offset.x * cos(rad) - corner_offset.y * sin(rad),
		corner_offset.x * sin(rad) + corner_offset.y * cos(rad)
	)

	var target_center = target_top_left - rotated_corner
	var target_pos = target_center - half_size + Vector2(783, -58)

	hide_menu_buttons()

	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", target_pos, 0.5)
	tween.tween_property(self, "rotation_degrees", target_rotation_deg, 0.5)
	await tween.finished
	pivot_offset = Vector2.ZERO
	self.global_position = cur_menu_pos
	self.rotation_degrees = cur_deg
	self.visible = false
	show_menu_buttons()

func hide_menu_buttons():
	$MarginContainer.visible = false
	$MarginContainer2.visible = false

func show_menu_buttons():
	$MarginContainer.visible = true
	$MarginContainer2.visible = true

func _on_act_1_pressed() -> void:
	Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_BUTTON_CLICKED)
	await flip_to(Global.game_manager.start_level_phone.left_corner.global_position,90.0)
	Global.game_manager.prep_first_act()


func _on_act_2_button_down() -> void:
	Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_BUTTON_CLICKED)


func _on_act_3_pressed() -> void:
	Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_BUTTON_CLICKED)


func _on_back_pressed() -> void:
	Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ON_BUTTON_CLICKED)
	await flip_to(Global.main_menu.left_corner.global_position,90.0)
	Global.main_menu.visible = true
