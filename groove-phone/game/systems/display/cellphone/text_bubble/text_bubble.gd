class_name TextBubble extends MarginContainer

static var scene_path = "res://game/systems/display/cellphone/text_bubble/TextBubble.tscn"
signal ready_to_position
var _current_text : String
@onready var NineTileRec : NinePatchRect = $NinetTileRec

static func create_text_bubble(node : Node) -> TextBubble:
	var tmp_scene : PackedScene = load(scene_path)
	var text_bubble = tmp_scene.instantiate()
	node.add_child(text_bubble)
	return text_bubble

func set_text(new_text : String):
	if new_text == _current_text:
		return
	_current_text = new_text
	modulate.a = 0.0
	$MarginContainer/Text.text = new_text
	await $MarginContainer.minimum_size_changed
	offset_right = 0
	offset_left = -size.x
	offset_bottom = 0
	offset_top = -size.y
	modulate.a = 1.0
	emit_signal("ready_to_position")  # fire AFTER size is final

func flip_horizontal():
	$NinetTileRec.set_shader

func set_position_from_bottom(pos : Vector2):
	self.position = pos 
