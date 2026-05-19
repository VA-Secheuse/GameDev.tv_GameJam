class_name TextComposer extends Node

static var text_composer_scene_path : String = "res://game/systems/text_composer/TextComposer.tscn"

var rhythm_manager: RhythmManager

var cellphone : CellPhone


var player_sentence_array : Array = [{'is_end':'yes','sentence':["lopopeloas",'you', 'like','potato']}]
var cur_player_dialogue : int = 0
var cur_player_dialogue_word : int = 0
var cur_player_sentence : Dictionary


var who_is_typing : String = 'player'

var recipient_sentence_array : Array = [{'is_end':"no",'sentence' : "no i dont like potato"},{'is_end':"yes",'sentence' :"i love permesean"}]
var cur_recipient_dialogue : int = 0

func start_text_composer():
	cur_player_sentence = player_sentence_array[cur_player_dialogue]

func set_rhythm_manager(rhythm_manager):
	self.rhythm_manager = rhythm_manager
func set_cellphone(cellphone : CellPhone):
	self.cellphone = cellphone

func _process(delta: float) -> void:
	pass

func next_player_word():
	var next_input_info : Array = rhythm_manager.when_is_next_input()
	if next_input_info[0] == 'send' and cur_player_sentence["is_end"] == 'no':
		cellphone.send_player_message_in(next_input_info[1])
		change_player_sentence()
	elif next_input_info[0] == 'send' and cur_player_sentence["is_end"] == 'yes':
		change_player_sentence()
		who_is_typing = 'recipient'
	else :
		var cur_word : Array = cur_player_sentence['sentence']
		if cur_word.size() <= cur_player_dialogue_word :
			return
		cellphone.show_next_player_word(cur_word[cur_player_dialogue_word],next_input_info[1])
		cur_player_dialogue_word += 1

func change_player_sentence() -> void:
	cur_player_dialogue +=1
	cur_player_dialogue_word = 0
	if cur_player_dialogue < player_sentence_array.size():
		cur_player_sentence = player_sentence_array[cur_player_dialogue]

func next_recipient_sentences(beat_ms : float):
	var sentences : Array
	
	##error handling
	if recipient_sentence_array.size() <= cur_recipient_dialogue:
		return
	
	while true :
		if recipient_sentence_array[cur_recipient_dialogue]['is_end'] == 'yes' :
			sentences.append(recipient_sentence_array[cur_recipient_dialogue]['sentence'])
			cur_recipient_dialogue += 1
			cellphone.send_recipient_messages(sentences)
			break
		elif recipient_sentence_array[cur_recipient_dialogue]['is_end'] == 'no':
			sentences.append(recipient_sentence_array[cur_recipient_dialogue]['sentence'])
			cur_recipient_dialogue += 1
		else:
			break

func _recipient_last_message_sent() :
	who_is_typing = 'player'

func input_pressed_and_checked(success : bool,button : String,beat_ms : float):
	if button == 'send' && who_is_typing == 'recipient':
		cellphone.send_player_message(success)
		next_recipient_sentences(beat_ms)
	if button == 'send' && who_is_typing == 'player':
		cellphone.send_player_message(success)
	else :
		cellphone.finish_current_word(success)
		next_player_word()
	
