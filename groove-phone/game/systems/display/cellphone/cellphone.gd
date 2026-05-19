class_name CellPhone extends Node2D

static var cellphone_scene_path : String = "res://game/systems/display/cellphone/CellPhone.tscn"
var cur_rectangle : RectangleQueue
var rectangle_array : Array = []

@onready var text_bubble_container  =$MarginContainer/ScrollContainer/VBoxContainer
@onready var scroll = $MarginContainer/ScrollContainer
var cur_sentence : String
var old_sentence : String = ""
var cur_word : String
var cur_letter : int = 0

var timer : Timer

func _ready() -> void:
	text_bubble_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_bubble_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var spacer = Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	text_bubble_container.add_child(spacer)
	text_bubble_container.move_child(spacer, 0)

func make_rectangle_fall_at_target_row(row_number : int , square_color : String, word : String,time_of_falling : float):
	
	##Create and set the attribute of a new rectangle
	var tmp_scene :PackedScene = load(RectangleQueue.scene_path)
	var rectangle_cue : RectangleQueue = tmp_scene.instantiate()
	rectangle_cue.set_all(square_color,word)
	$Cue.add_child(rectangle_cue)
	rectangle_array.push_back(rectangle_cue)
	
	match row_number:
		1:
			rectangle_cue.position = $SpawnMarkers/Position1Start.position
			rectangle_cue.move_to($SpawnMarkers/Position1End.position,time_of_falling)
		2:
			rectangle_cue.position = $SpawnMarkers/Position2Start.position
			rectangle_cue.move_to($SpawnMarkers/Position2End.position,time_of_falling)
		3:
			rectangle_cue.position = $SpawnMarkers/Position3Start.position
			rectangle_cue.move_to($SpawnMarkers/Position3End.position,time_of_falling)
		4:
			rectangle_cue.position = $SpawnMarkers/Position4Start.position
			rectangle_cue.move_to($SpawnMarkers/Position4End.position,time_of_falling)
		5:
			rectangle_cue.position = $SpawnMarkers/Position5Start.position
			rectangle_cue.move_to($SpawnMarkers/Position5End.position,time_of_falling)
			print('hugaakkak')
	return rectangle_cue

func _show_next_cue(time : float,beat_info : Dictionary):
	if beat_info == {}:
		pass
	elif beat_info['type'] != 'empty':
		var rec = make_rectangle_fall_at_target_row(beat_info['row'],beat_info['type'],'test',time)
		rec.associated_beat = beat_info['beat']

func _pop_rectangle_for_beat(beat : int) -> RectangleQueue:
	for i in range(rectangle_array.size()):
		if rectangle_array[i].associated_beat == beat:
			return rectangle_array.pop_at(i)
	return null

func show_next_player_word(word : String, in_ms : float):
	
	cur_word = word
	cur_letter = 0
	
	var word_lenght = word.length()
	
	if word_lenght == 0:
		return
	
	var time_per_letter = (in_ms/float(word_lenght)) /1000
	
	if timer:
		timer.stop()
		timer.queue_free()
	
	timer = Timer.new()
	timer.one_shot = false
	timer.autostart = false
	timer.wait_time = time_per_letter
	add_child(timer)
	timer.timeout.connect(self.show_next_letter)
	timer.start()

func show_next_letter():
	if cur_word.length() <= cur_letter:
		if timer:
			timer.stop()
		return
	cur_sentence += cur_word[cur_letter]
	cur_letter +=1
	$Label.text = cur_sentence

func finish_current_word(success : bool):
	if timer:
		timer.stop()
		timer.queue_free()
		timer = null
	
	cur_sentence = old_sentence + cur_word + " "
	old_sentence = cur_sentence
	$Label.text = cur_sentence

func send_player_message_in(in_ms : float):
	pass

func send_player_message(success : bool):
	pass

func send_recipient_messages(sentence : Array):
	pass

func _on_success(beat : int):
	var rec = _pop_rectangle_for_beat(beat)
	if rec and is_instance_valid(rec):
		rec.success_animation()

func _on_failure(beat : int):
	var rec = _pop_rectangle_for_beat(beat)
	if rec and is_instance_valid(rec):
		rec.failed_animation()

#func _process(delta: float) -> void:
	#if(Input.is_action_just_pressed('Enter')):
		#_new_player_speak_bubble('bo')
	#if(Input.is_action_just_pressed("a_input")):
		#_new_recipient_speak_bubble('oooooooaaaaaaaaaaaaa')

func _new_player_speak_bubble(text : String):
	var new_bubble = TextBubble.create_text_bubble(text_bubble_container)
	new_bubble.size_flags_horizontal = Control.SIZE_SHRINK_END
	new_bubble.set_text(text)
	await new_bubble.ready_to_position  # now size.x/y are correct
	await get_tree().process_frame
	scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value

func _new_recipient_speak_bubble(text : String) :
	var new_bubble = TextBubble.create_text_bubble(text_bubble_container)
	new_bubble.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	new_bubble.set_text(text)
	await new_bubble.ready_to_position  # now size.x/y are correct
	await get_tree().process_frame
	scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value
