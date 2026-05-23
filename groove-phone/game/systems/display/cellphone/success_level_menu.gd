extends Node2D
class_name SuccessLevelMenu

@export var score : Label
@export var highest : Label

var hide : bool = false

func show_success_menu(score : int, highest : bool):
	self.visible = true
	self.highest.visible = false
	self.score.text = 'Score : ' + str(score)
	if highest:
		_show_highest()

func _show_highest():
	highest.visible = true
	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($combo, "scale", Vector2(1.1, 1.1), 0.5)
	tween.tween_property($combo, "scale", Vector2(1.0, 1.0), 0.5)

func _on_hide_pressed() -> void:
	for child in $".".get_children():
		if !hide :
			child.visible = false
		else:
			child.visible = true
	
	if hide:
		hide = false
	else:
		hide = true
	$Hide.visible = true

func _on_restart_pressed() -> void:
	Global.current_rhythm_manager.restart_level()

func _on_main_menu_pressed() -> void:
	Global.current_rhythm_manager.exit_level()
	Global.main_menu.open()
