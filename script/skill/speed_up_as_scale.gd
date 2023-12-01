extends SkillData

var fixed_paramter := 0



func trigger():
	var window_data :WindowData = owner
	var _vec = window_data.window_cur_size / window_data.init_window_size
	var ori_scale_speed = window_data.enemy_scale_speed - fixed_paramter
	
	var orien = HORIZONTAL if max(_vec.x, _vec.y) == _vec.x else VERTICAL
	var rate := 0.5
	
	
	if orien == HORIZONTAL:
		var max_ratio = window_data.active_area.size.x / window_data.init_window_size.x
		var min_scale_speed = ori_scale_speed
		var max_scale_speed = 3
		
		fixed_paramter = max_scale_speed - _vec.x * rate
		
		#print([fixed_paramter, min_scale_speed, max_scale_speed])
		skill_triggered.emit('set_enemy_scale_speed', [fixed_paramter + ori_scale_speed])
	elif orien == VERTICAL:
		var max_ratio = window_data.active_area.size.y / window_data.init_window_size.y
		var min_scale_speed = ori_scale_speed
		var max_scale_speed = 3
		
		fixed_paramter = max_scale_speed - _vec.y * rate
		
		#print([fixed_paramter, min_scale_speed, max_scale_speed])
		skill_triggered.emit('set_enemy_scale_speed', [fixed_paramter + ori_scale_speed])
		
func _init() -> void:
	cool_time = 10
	pass
