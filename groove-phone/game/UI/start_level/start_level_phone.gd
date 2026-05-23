extends Node2D
class_name StartLevelPhone

var mouse_in : bool = false

var can_lauch : bool = false

var bubble_flicker : Tween 

var cur_act : String

signal start_first_act
signal start_second_act
signal start_third_act

@export var notif_bubble : Sprite2D

@export var notif_logo : Sprite2D

@export var left_corner : Marker2D

var still_in_menu : bool = true

func _on_area_2d_mouse_entered() -> void:
	if can_lauch :
		mouse_in = true
		$PhoneSprite.material.set_shader_parameter("outline_width", 2.5)

func _on_area_2d_mouse_exited() -> void:
	if can_lauch : 
		mouse_in = false
		$PhoneSprite.material.set_shader_parameter("outline_width", 0)

func _process(delta: float) -> void:
	if can_lauch && mouse_in && Input.is_action_just_pressed('left_click') && cur_act == 'act1':
		bubble_flicker.kill()
		start_first_act.emit()
		can_lauch = false
		mouse_in = false
	elif can_lauch && mouse_in && Input.is_action_just_pressed('left_click') && cur_act == 'act2':
		bubble_flicker.kill()
		start_second_act.emit()
		can_lauch = false
		mouse_in = false
	elif can_lauch && mouse_in && Input.is_action_just_pressed('left_click') && cur_act == 'act3':
		bubble_flicker.kill()
		start_third_act.emit()
		can_lauch = false
		mouse_in = false

func first_act_start_animation() -> void:
	if still_in_menu : 
		cur_act = 'act1'
		notif_bubble.visible = true
		notif_logo.visible = true
		active_bubble()
		Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.OBJ_PHONE_NOTIFICATION)
		can_lauch = true

func second_act_start_animation() -> void:
	if still_in_menu : 
		cur_act = 'act2'
		notif_bubble.visible = true
		notif_logo.visible = true
		active_bubble()
		Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.OBJ_PHONE_NOTIFICATION)
		can_lauch = true

func third_act_start_animation() -> void:
	if still_in_menu : 
		cur_act = 'act3'
		notif_bubble.visible = true
		notif_logo.visible = true
		active_bubble()
		Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.OBJ_PHONE_NOTIFICATION)
		can_lauch = true

func open():
	self.visible = true
	self.still_in_menu = true

func active_bubble():
	bubble_flicker = create_tween()
	bubble_flicker.set_loops()
	bubble_flicker.tween_property(notif_bubble,'scale',Vector2(1.2, 1.2),0.6)
	bubble_flicker.tween_property(notif_bubble,'scale',Vector2(1.0, 1.0),0.3)

func reset_and_hide():
	if bubble_flicker:
		bubble_flicker.kill()
	cur_act = ''
	still_in_menu = false
	$NotifBubble.visible = false
	$NotifLogo.visible = false

func scale_to(target_left_corner: Vector2, target_scale: Vector2, duration: float = 0.5) -> void:
	var old_position = self.global_position
	var cur_scale = self.scale

	var corner_offset = left_corner.global_position - self.global_position
	var target_position = target_left_corner - corner_offset + Vector2(91, 0)

	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	reset_and_hide()
	tween.tween_property(self, "global_position", target_position, duration)
	tween.tween_property(self, "scale", target_scale, duration)
	await tween.finished
	self.visible = false
	self.scale = cur_scale
	self.global_position = old_position

func _on_back_mouse_entered() -> void:
	$back.material.set_shader_parameter("outline_width", 1.5)

func _on_back_mouse_exited() -> void:
	$back.material.set_shader_parameter("outline_width", 0.0)

func _on_back_pressed() -> void:
	Global.sound_manager.play_main_menu_music()
	reset_and_hide()
	await flip_to(Global.act_selection.left_corner.global_position,-90.0)
	Global.act_selection.show_menu()

func flip_to(target_top_left: Vector2, target_rotation_deg: float) -> void:
	var cur_pos = self.global_position
	var cur_deg = self.rotation_degrees

	var half_size = get_half_size()
	var rad = deg_to_rad(target_rotation_deg)

	var corner_offset = Vector2(-half_size.x, -half_size.y)
	var rotated_corner = Vector2(
		corner_offset.x * cos(rad) - corner_offset.y * sin(rad),
		corner_offset.x * sin(rad) + corner_offset.y * cos(rad)
	)

	var target_center = target_top_left - rotated_corner
	var target_pos = target_center - half_size + Vector2(234,0)

	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", target_pos, 0.5)
	tween.tween_property(self, "rotation_degrees", target_rotation_deg, 0.5)
	await tween.finished
	self.global_position = cur_pos
	self.rotation_degrees = cur_deg
	self.visible = false

func get_half_size() -> Vector2:
	var top_left = $LeftCorner.global_position
	var center = self.global_position 
	return center - top_left
