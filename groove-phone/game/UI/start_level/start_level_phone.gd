extends Node2D
class_name StartLevelPhone

var mouse_in : bool = false

var can_lauch : bool = false

var bubble_flicker : Tween 

signal start_first_act

@export var notif_bubble : Sprite2D

@export var notif_logo : Sprite2D

@export var left_corner : Marker2D

func _on_area_2d_mouse_entered() -> void:
	if can_lauch :
		mouse_in = true
		$PhoneSprite.material.set_shader_parameter("outline_width", 2.5)

func _on_area_2d_mouse_exited() -> void:
	if can_lauch : 
		mouse_in = false
		$PhoneSprite.material.set_shader_parameter("outline_width", 0)

func _process(delta: float) -> void:
	if can_lauch && mouse_in && Input.is_action_just_pressed('left_click'):
		bubble_flicker.kill()
		start_first_act.emit()
		can_lauch = false
		mouse_in = false
	if can_lauch && Input.is_action_just_pressed('pause'):
		Global.pause_menu.open_pause_menu()

func first_act_start_animation() -> void:
	notif_bubble.visible = true
	notif_logo.visible = true
	active_bubble()
	Global.sound_manager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.NOTIFICATION)
	can_lauch = true

func active_bubble():
	bubble_flicker = create_tween()
	bubble_flicker.set_loops()
	bubble_flicker.tween_property(notif_bubble,'scale',Vector2(1.2, 1.2),0.6)
	bubble_flicker.tween_property(notif_bubble,'scale',Vector2(1.0, 1.0),0.3)


func reset_and_hide():
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
