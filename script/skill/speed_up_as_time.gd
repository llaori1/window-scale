extends SkillData

func trigger():
	var window_data :WindowData = owner
	
	if LevelData.get_level_data().remaining_time < 5:
		skill_triggered.emit("set_enemy_scale_speed", [window_data.enemy_scale_speed + 1])
		print('enemy speed up : ' + str(window_data.enemy_scale_speed))
	pass
