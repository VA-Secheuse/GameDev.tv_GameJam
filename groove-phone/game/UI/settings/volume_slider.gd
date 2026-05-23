extends HSlider

@export var bus_name: String
var bus_index: int

func _ready() ->void:
	min_value = 0.0
	max_value = 1.0
	step = 0.01
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(self._on_value_changed)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	value = 0.5

func update_value():
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))


func _on_value_changed(val: float) -> void:
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(val))
