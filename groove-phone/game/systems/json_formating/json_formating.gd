class_name JsonFormating

static func input_mapping_to_array(track: Track) -> Array:
	var notes : Array = []
	
	var parsed = track.button_mapping.data
	
	if parsed == null:
		push_error("Failed to parse chart JSON")
	notes = parsed["beats"]
	
	return notes

static func dialogue_mapping_to_array(track: Track) -> Dictionary:
	var result := {
		"P": [],
		"R": []
	}

	var parsed = track.dialogue_file.data

	if parsed == null:
		push_error("Failed to parse dialogue JSON")
		return result

	for speaker_data in parsed:
		var speaker = speaker_data["speaker"]
		var dialogue = speaker_data["dialogue"]

		if result.has(speaker):
			result[speaker].append_array(dialogue)

	return result
