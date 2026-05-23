extends TextureRect
class_name ActSelection

@export var left_corner : Marker2D


func show_menu() :
	_load_score()
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
	hide_menu_buttons()
	show_menu_buttons()

func hide_menu_buttons():
	$MarginContainer.visible = false
	$MarginContainer2.visible = false

func show_menu_buttons():
	$MarginContainer.visible = true
	$MarginContainer2.visible = true

func _on_act_1_pressed() -> void:
	await flip_to(Global.game_manager.start_level_phone.left_corner.global_position,90.0)
	Global.game_manager.prep_first_act()

func _on_act_2_button_down() -> void:
	if !Global.act_2_unlocked:
		_show_error_message()
		_not_unlocked_animation()
		_show_error_message()
		return
	await flip_to(Global.game_manager.start_level_phone.left_corner.global_position,90.0)
	Global.game_manager.prep_second_act()

func _on_act_3_pressed() -> void:
	if !Global.act_3_unlocked:
		_not_unlocked_animation()
		_show_error_message()
		return
	await flip_to(Global.game_manager.start_level_phone.left_corner.global_position,90.0)
	Global.game_manager.prep_third_act()

func _on_back_pressed() -> void:
	await flip_to(Global.main_menu.left_corner.global_position,90.0)
	Global.main_menu.visible = true

func _on_back_mouse_entered() -> void:
	$MarginContainer2/back.material.set_shader_parameter("outline_width", 1.5)

func _on_back_mouse_exited() -> void:
	$MarginContainer2/back.material.set_shader_parameter("outline_width", 0.0)

func _not_unlocked_animation() -> void:
	var origin = position
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", origin + Vector2(-10, 0), 0.1)
	tween.tween_property(self, "global_position", origin + Vector2(10, 0), 0.1)
	tween.tween_property(self, "global_position", origin + Vector2(-10, 0), 0.1)
	tween.tween_property(self, "global_position", origin, 0.1)

func _show_error_message() -> void:
	var tween = create_tween()
	tween.tween_callback(func(): $ErrorMessage/Label.visible = true)
	tween.tween_interval(2)
	tween.tween_callback(func(): $ErrorMessage/Label.visible = false)
	tween.tween_interval(0.5)

func _load_score() -> void:
	if Global.score_dic['act_1'] != 0:
		$MarginContainer3/HBoxContainer/Act1Score.text = "Score :\n" + str(Global.score_dic['act_1'])
	
	if Global.score_dic['act_2'] != 0:
		$MarginContainer3/HBoxContainer/Act2Score.text = "Score :\n" + str(Global.score_dic['act_2'])
	
	if Global.score_dic['act_3'] != 0:
		$MarginContainer3/HBoxContainer/Act3Score.text = "Score :\n" + str(Global.score_dic['act_3'])
