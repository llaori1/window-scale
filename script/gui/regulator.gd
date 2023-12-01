extends HBoxContainer

class_name Regulator

@onready var progress_bar: ProgressBar = $ProgressBar

signal value_changed

var name_label:String:
	set(val):
		$Name.text = val

func _on_minus_pressed() -> void:
	progress_bar.value -= progress_bar.step
	pass # Replace with function body.


func _on_plus_pressed() -> void:
	progress_bar.value += progress_bar.step
	pass # Replace with function body.


func set_value(val:float):
	progress_bar.value = val
	pass


func get_value():
	return progress_bar.value



func _on_progress_bar_value_changed(value: float) -> void:
	value_changed.emit(progress_bar.value)
