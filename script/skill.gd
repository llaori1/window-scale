extends Base

class_name SkillData

signal skill_triggered()

var name := ''
var owner
var cool_time := 500:
	set(val):
		cool_time = val
		last_cool_time = val
var is_cool_down := false
var last_cool_time := 5

func check_skill(delta:float):
	last_cool_time -= delta
	if last_cool_time <= 0:
		trigger()
		last_cool_time = cool_time


func trigger():
	skill_triggered.emit()

func _init() -> void:
	
	pass
