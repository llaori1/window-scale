extends SkillData


var fixed_paramter = 300
var start_time = 0
var snap



func check_skill(delta:float):
	if Time.get_ticks_msec() / 1000 >= start_time + 4:
		trigger()
		start_time = Time.get_ticks_msec() / 1000
	pass
	
func trigger():
	var window_data :WindowData = owner
	skill_triggered.emit('set_enemy_move_speed',[window_data.window_move_speed + fixed_paramter])
	
	await GlobalResourceLoader.create_my_timer(3)
	
	skill_triggered.emit('set_enemy_move_speed',[window_data.window_move_speed - fixed_paramter])


func _init() -> void:
	pass
