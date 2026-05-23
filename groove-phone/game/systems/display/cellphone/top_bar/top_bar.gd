extends Node2D
class_name TopBar

@onready var full = $FullWifi
@onready var empty = $EmptyWifi

var current_bars : int = 6
var max_bars : int =  6

var combo_tween : Tween

func lose_bar() -> void:
	if current_bars <= 0:
		return
	current_bars -= 1
	_update_display()
	shake_bar()

func gain_bar() -> void:
	if current_bars >= max_bars:
		return
	current_bars += 1
	scale_bar()
	_update_display()

func set_bars(amount: int) -> void:
	current_bars = clamp(amount, 0, max_bars)
	_update_display()

func reset_bar():
	set_bars(6)

func set_all_invisible():
	for child in $AllBars/Bars.get_children():
		child.visible = false

func _update_display() -> void:
	set_all_invisible()
	match current_bars:
		1:
			$AllBars/Bars/OneBar.visible = true
		2:
			$AllBars/Bars/TwoBar.visible = true
		3:
			$AllBars/Bars/ThreeBar.visible = true
		4:
			$AllBars/Bars/FourBar.visible = true
		5:
			$AllBars/Bars/FiveBar.visible = true
		6:
			$AllBars/Bars/FullWifi.visible = true

func set_score(score : int) ->void:
	$score.text = str(score)

func update_combo(combo : int):
	if combo == 0:
		$combo.text = ''
		combo_kill()
	else:
		$combo.text = 'x' + str(combo)
		combo_animate()

func combo_animate():
	if !combo_tween:
		combo_tween = create_tween()
		combo_tween.set_loops()
		combo_tween.set_trans(Tween.TRANS_SINE)
		combo_tween.set_ease(Tween.EASE_IN_OUT)
		combo_tween.tween_property($combo, "scale", Vector2(1.1, 1.1), 0.5)
		combo_tween.tween_property($combo, "scale", Vector2(1.0, 1.0), 0.5)

func combo_kill():
	if combo_tween:
		combo_tween.kill()
		combo_tween = null
		$combo.scale = Vector2(1.0, 1.0)

func shake_bar() -> void:
	var origin = position
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($AllBars, "global_position", origin + Vector2(-10, 0), 0.1)
	tween.tween_property($AllBars, "global_position", origin + Vector2(10, 0), 0.1)
	tween.tween_property($AllBars, "global_position", origin + Vector2(-10, 0), 0.1)
	tween.tween_property($AllBars, "global_position", origin, 0.1)

func scale_bar() -> void:
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property($AllBars, "scale", Vector2(1.1, 1.1), 0.2)
		tween.tween_property($AllBars, "scale", Vector2(1.0, 1.0), 0.2)
