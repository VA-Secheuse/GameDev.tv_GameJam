class_name TextBubble extends MarginContainer

static var scene_path = "res://game/systems/display/cellphone/text_bubble/TextBubble.tscn"
signal ready_to_position
var _current_text : String
@onready var nine_tile_rec : NinePatchRect = $NinetTileRec

static func create_text_bubble(node : Node) -> TextBubble:
	var tmp_scene : PackedScene = load(scene_path)
	var text_bubble = tmp_scene.instantiate()
	node.add_child(text_bubble)
	return text_bubble

func set_text(new_text : String, side : bool):
	
	##THIS IS FOR SHOWING DATE ITS UGLY
	if new_text[0] == '2' && !side:
		var dat_str = new_text.substr(1)
		self.set_flip(true)
		$NinetTileRec.visible = false
	
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
	
	##new_text[0] != '2', that is for showing the date too
	if !side && new_text[0] != '2':
		self.set_flip(true)
		$NinetTileRec.visible = false
		$Recipient.visible = true
	emit_signal("ready_to_position")

func set_flip(is_player: bool):
	if is_player:
		nine_tile_rec.scale.x = -1
		nine_tile_rec.position.x = nine_tile_rec.size.x 
	else:
		nine_tile_rec.scale.x = 1
		nine_tile_rec.position.x = 0

func set_position_from_bottom(pos : Vector2):
	self.position = pos 
