class_name test_level extends Node2D

@onready var rec1 = $square1
@onready var rec2 = $ColorRect 
@onready var rec3 = $ColorRect2

@export var Rhythm_manager : RhythmManager


func update_color():
	switch_rec_color(Rhythm_manager.get_beat_button_in(-1),rec1)
	switch_rec_color(Rhythm_manager.get_beat_button_in(0),rec2)
	switch_rec_color(Rhythm_manager.get_beat_button_in(1),rec3)

func switch_rec_color(color , rec : ColorRect):
	match color:
		"blue":
			rec.color = Color("#05ffff")
		"yellow":
			rec.color = Color("#ffff00")
		"red":
			rec.color = Color("#ff0000")
		"pink":
			rec.color = Color("#ff69b4")
		"send":
			rec.color = Color("#000000")
		_:
			rec.color = Color(1.0, 1.0, 1.0, 1.0)


func _on_rhythm_manager_tmp_signal() -> void:
	update_color()


func _on_rhythm_manager_tmp_2(message: Variant) -> void:
	$Label.text = message
