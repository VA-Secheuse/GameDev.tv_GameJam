class_name JsonFormating

static func input_mapping_to_array(track: Track) -> Array:
	var notes : Array = []
	
	var parsed = track.button_mapping.data
	
	if parsed == null:
		push_error("Failed to parse chart JSON")
	notes = parsed["beats"]
	
	return notes
