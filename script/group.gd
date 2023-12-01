extends Node

enum group {
	level_set = 100,
	
	game = 200,
	
	window_set = 300,
}

var init_data :Dictionary = {
}

signal group_signal()

@export var _group :Dictionary

func _init() -> void:
	
	var size = int(group.values().max() / 100)
	# 初始化空组
	for i in size:
		var idx = i * 100 + 100
		var arr_name = group.find_key(idx)
		if arr_name!=null:
			var is_nested := false
			_group[arr_name] = {}
			for j in range(1,100):
				var nested_arr_name = group.find_key(idx+j)
				if nested_arr_name!=null:
					is_nested = true
					if init_data.has(idx+j):
						_group[arr_name][nested_arr_name] = init_data[idx+j]
						continue
					_group[arr_name][nested_arr_name] = []
			if not is_nested:
				_group[arr_name] = []
	pass
func add_to_mygroup(group_name:group,_object)->void:
	var arr = parsor_group_name(group_name)
	arr.append(_object)

	#if _object is Object:
		#if "add_to_mygroup" in _object:
			#_object.add_to_mygroup()

func get_first_node_in_group(group_name:group):
	var arr = parsor_group_name(group_name)
	if arr.size()>0:
		return arr[0]
	else:
		return null
		
func is_in_mygroup(group_name:group,_object)->bool:
	var arr = parsor_group_name(group_name)
	if _object in arr:
		return true
	else:
		return false
		
func get_nodes_in_group(group_name:group):
	var arr = parsor_group_name(group_name)
	return arr

func clear_group(group_name:group)->void:
	var arr = parsor_group_name(group_name)
	arr.clear()
func clear_group_complete(group_name:group)->void:
	var arr = parsor_group_name(group_name)
	for item in arr:
		if "queue_free" in item:
			item.queue_free()
	arr.clear()
	pass

# 返回数组
func parsor_group_name(group_name:group):
	if group_name % 100 == 0:
		var a_group = _group[group.find_key(group_name)]
#		if not arr is Array:
#			assert(false,"数据类型错误")
		return a_group
	else:
		var idx = group_name-(group_name%100)
		var parent_dir = group.find_key(idx)
		var self_dir = group.find_key(group_name)
		var a_group = _group[parent_dir][self_dir]
#		if not arr is Array:
#			assert(false,"数据类型错误")
		return a_group

