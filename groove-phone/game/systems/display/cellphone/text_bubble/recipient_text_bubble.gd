class_name RecipientTextInfo extends MarginContainer

static var recipient_text_bubble = "res://game/systems/display/cellphone/text_bubble/RecipientTextBubble.tscn"

var cur_beat := 0
var current_repeat := 0
var repeat_count := 0

signal ready_to_position
signal animation_finished


static func create_text_info(node: Node) -> RecipientTextInfo:
	var tmp_scene: PackedScene = load(recipient_text_bubble)
	var recipient_info: RecipientTextInfo = tmp_scene.instantiate()
	recipient_info.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	node.add_child(recipient_info)
	return recipient_info


func start_dot_animation(p_repeat := 5):
	repeat_count = p_repeat

	cur_beat = 0
	current_repeat = 0

	$MarginContainer/Text.text = ""

	emit_signal("ready_to_position")


func on_music_beat():
	# Beat 1 2 3
	if cur_beat < 3:
		$MarginContainer/Text.text += "."

	# Beat 4
	elif cur_beat == 3:
		emit_signal("animation_finished")

		$MarginContainer/Text.text = ""

		current_repeat += 1

		if current_repeat >= repeat_count:
			queue_free()
			return

		cur_beat = -1

	cur_beat += 1
