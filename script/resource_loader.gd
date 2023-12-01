extends Node

enum {
	NEXT_LEVEL,
	LAST_LEVEL,
	CUR_LEVEL,
}

const INIT_LEVEL = '1'

const PATH_DIC := {
	'skill':"res://script/skill/",
}

var archive_dic := {
	'level':[],
	'window':[],
}

#var resource_dic := {
	#'level':[]
#}

func _ready() -> void:
	load_data()
	load_level(NEXT_LEVEL)

func load_data():
	#archive_dic['level'] = parse_csv_file(PATH_DIC['level'],'name')
	#archive_dic['window'] = parse_csv_file(PATH_DIC['window'],'name')
	archive_dic = load("res://script/game_data.res").archive_dic
	#var resource = GameData.new()
	#resource.archive_dic = archive_dic
	#var suc = ResourceSaver.save(resource, 'res://script/game_data.res')
	#print(suc)
func load_level(flag_level):
	var level_name := ''
	var cur_level_name := 1
	var level_data = LevelData.get_level_data()
	if level_data == null:
		flag_level = INIT_LEVEL
		cur_level_name = 1
	else:
		cur_level_name = level_data.name
	match flag_level:
		INIT_LEVEL:
			level_name = INIT_LEVEL
		NEXT_LEVEL:
			level_name = str(cur_level_name + 1)
		CUR_LEVEL:
			level_name = str(cur_level_name)
		LAST_LEVEL:
			level_name = str(cur_level_name - 1)
	if archive_dic['level'].has(level_name):
		var new_level = create_level(level_name)
		Group.clear_group_complete(Group.group.window_set)
		Group.clear_group_complete(Group.group.level_set)
		
		for i in new_level.window_numbers:
			var new_window = create_window(new_level.window_names[i])
			for skill_name in new_window.skill_names:
				if skill_name != 'none':
					var new_skill = create_skill(skill_name)
					new_skill.owner = new_window
					new_window.enemy_skills.append(new_skill)
			new_window.add_to_mygroup(Group.group.window_set)
		new_level.add_to_mygroup(Group.group.level_set)
	else:
		assert(false,'no such level!')
	return LevelData.get_level_data()


func create_level(level_name:String) -> LevelData:
	if archive_dic['level'] != null and archive_dic['level'].has(level_name):
		var new_level
		new_level = LevelData.new(archive_dic['level'][level_name])
		
		return new_level
	else:
		assert(false,'no such level')
		return

func create_window(window_name:String) -> WindowData:
	if archive_dic['window'] != null and archive_dic['window'].has(window_name):
		var new_window
		new_window = WindowData.new(archive_dic['window'][window_name])
		
		return new_window
	else:
		assert(false,'no such window')
		return

func create_skill(skill_name:String) -> SkillData:
	var skill_path := PATH_DIC['skill'] + skill_name + '.gd'
	if ResourceLoader.exists(skill_path):
		var new_skill = load(skill_path).new()
		return new_skill
	else:
		assert(false,'no such skill')
	return
	pass

func load_file(file_path:String)->Array:
	if file_path.ends_with('/'):
		file_path = file_path.rstrip('/')
	var file_name :=[]
	var dir_access = DirAccess.open(file_path)
	if dir_access != null:
		dir_access.list_dir_begin()
		var dir = dir_access.get_next()
		# 先读取所有路径
		while dir != "" :
			if dir_access.current_is_dir():
				file_name.append_array(load_file(file_path+"/"+dir))
			else:
				file_name.append(file_path+"/"+dir)
			dir = dir_access.get_next()
		dir_access.list_dir_end()
	return file_name

func create_my_timer(time_sec: float, process_always: bool = true, process_in_physics: bool = false, ignore_time_scale: bool = false):
	return await get_tree().create_timer(time_sec, process_always, process_in_physics, ignore_time_scale).timeout
	
