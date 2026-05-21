class_name RectangleQueue extends Node2D

static var scene_path := "res://game/systems/display/cellphone/rectangle_queue.tscn"
var associated_beat : int = -1

func set_all(color:String,text:String):
	self._set_color(color)
	self._set_text(text)

func _set_color(color : String):
	match color:
		'blue':
			$Rectangle.frame = 0
		'pink':
			$Rectangle.frame = 2
		'yellow':
			$Rectangle.frame = 3
		'red':
			$Rectangle.frame = 1
		_:
			$Rectangle.frame = 4

func _set_text(text : String):
	$Label.text = text

var move_tween : Tween


func move_to(target_pos: Vector2, duration: float):
	move_tween = create_tween()
	modulate.a = 0.1
	
	var margin_duration = Global.current_rhythm_manager.current_track.margin /1000
	var total_duration = duration + margin_duration
	
	# Velocity based on start→target, continue past target at same speed
	var velocity = (target_pos - self.position) / duration
	var final_pos = target_pos + velocity * margin_duration
	move_tween.tween_property(self, "position", final_pos, total_duration)
	move_tween.parallel().tween_property(self, "modulate:a", 0.7, duration)

func success_animation():
	if move_tween: move_tween.kill() 
	var tween = create_tween()
	$WhiteOutline.visible = true
	$WhiteOutline.scale = Vector2(2.9, 2.9) 
	modulate.a = 1.0
	
	tween.tween_property($WhiteOutline, "scale", Vector2(3.1, 3.1), 0.6)
	tween.tween_callback(func(): $WhiteOutline.visible = false)
	$ThumbsStartingAnimation/Thumbs.visible = true
	var original_pos = $ThumbsStartingAnimation.position
	var shake_tween = create_tween()
	shake_tween.tween_property($ThumbsStartingAnimation, "position", original_pos + Vector2(randf_range(3.0, 6.0), randf_range(-3.0, -6.0)), 0.6)
	tween.tween_callback(func(): queue_free())

func failed_animation():
	if move_tween: move_tween.kill() 
	var tween = create_tween()
	modulate.a = 1.0
	$RedOutline.visible = true
	$RedOutline.scale = Vector2(2.9, 2.9) 
	tween.tween_property($RedOutline, "scale", Vector2(3.1, 3.1), 0.6)
	tween.tween_callback(func(): $RedOutline.visible = false)
	$ThumbsStartingAnimation/Thumbs.visible = true
	var original_pos = $ThumbsStartingAnimation.position
	$ThumbsStartingAnimation/Thumbs.frame = 1
	$ThumbsStartingAnimation/Thumbs.flip_v = true
	var shake_tween = create_tween()
	shake_tween.tween_property($ThumbsStartingAnimation, "position", original_pos + Vector2(randf_range(3.0, 6.0), randf_range(-3.0, -6.0)), 0.6)
	tween.tween_callback(func(): queue_free())

func get_height():
	return $Rectangle.texture.get_height()
	
