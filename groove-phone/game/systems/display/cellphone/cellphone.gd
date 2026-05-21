class_name CellPhone extends Node2D

static var cellphone_scene_path : String = "res://game/systems/display/cellphone/CellPhone.tscn"
var cur_rectangle : RectangleQueue
var rectangle_array : Array = []

var rhythm_manager : RhythmManager


@onready var text_bubble_container  =$MarginContainer/ScrollContainer/VBoxContainer
@onready var scroll = $MarginContainer/ScrollContainer
var cur_sentence : String
var old_sentence : String = ""
var cur_word : String
var cur_letter : int = 0
var cur_recipient_sentence : String = ""
var info

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
	
	var height_offset: float = rectangle_cue.get_height()/4
	
	var start_pos: Vector2
	var end_pos: Vector2
	match row_number:
		1:
			rectangle_cue.position = $SpawnMarkers/Position1Start.position
			rectangle_cue.move_to($SpawnMarkers/Position1End.position - Vector2(0, height_offset),time_of_falling)
		2:
			rectangle_cue.position = $SpawnMarkers/Position2Start.position
			rectangle_cue.move_to($SpawnMarkers/Position2End.position - Vector2(0, height_offset) ,time_of_falling)
		3:
			rectangle_cue.position = $SpawnMarkers/Position3Start.position
			rectangle_cue.move_to($SpawnMarkers/Position3End.position- Vector2(0, height_offset) ,time_of_falling)
		4:
			rectangle_cue.position = $SpawnMarkers/Position4Start.position
			rectangle_cue.move_to($SpawnMarkers/Position4End.position - Vector2(0, height_offset),time_of_falling)
		5:
			rectangle_cue.position = $SpawnMarkers/Position5Start.position
			rectangle_cue.move_to($SpawnMarkers/Position5End.position - Vector2(0, height_offset) ,time_of_falling)
		
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
	flicker_animation()
	self._new_player_speak_bubble(self.cur_sentence)
	$Label.text = ''
	cur_sentence = ''
	old_sentence=''
	cur_word =''

func send_recipient_messages(sentences: Array, beat_ms: float):
	_recipient_writing_bubble(beat_ms,sentences.size())

	for sentence in sentences:
		await info.animation_finished
		_new_recipient_speak_bubble(sentence)
		

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
	new_bubble.set_text(text,true)
	await new_bubble.ready_to_position
	await get_tree().process_frame
	scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value

func _new_recipient_speak_bubble(text : String) :
	var new_bubble = TextBubble.create_text_bubble(text_bubble_container)
	new_bubble.set_text(text, false)
	text_bubble_container.move_child(info, -1)
	await new_bubble.ready_to_position
	await get_tree().process_frame
	scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value

func _recipient_writing_bubble(beat_ms: float, repeat: int):
	self.info = RecipientTextInfo.create_text_info(text_bubble_container)
	text_bubble_container.move_child(info, -1)
	info.start_dot_animation(repeat)
	rhythm_manager.beat_changed.connect(info.on_music_beat)
	await info.ready_to_position
	return info

func set_rhythm_manager(rhythm_manager : RhythmManager):
	self.rhythm_manager = rhythm_manager

func flicker_animation():
	var tween = create_tween()
	var flicker_deg : float = randf_range(1.0,1.5)
	tween.tween_property(self,'rotation_degrees',flicker_deg,0.1)
	tween.tween_property(self,'rotation_degrees',0,0.1)
