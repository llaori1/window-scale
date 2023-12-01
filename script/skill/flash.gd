extends SkillData



func trigger():
	var window_data :WindowData= owner
	var window_size = window_data.window_cur_size
	
	var active_area = window_data.active_area
	var size = active_area.size
	var pos = active_area.position
	var ran_pos = Vector2(fmod(randi(), size.x - window_size.x - 1) + pos.x + 1, fmod(randi(), size.y - window_size.y - 1) + pos.y + 1)
	
	skill_triggered.emit('set_window_global_position', [ran_pos])
	print('enemy flash!')
