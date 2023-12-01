extends Resource

class_name Base


func _init(dic:Dictionary = {}) -> void:
	for property in dic:
		if property in self:
			if self[property] is bool:
				self[property] = true if dic[property] == "TRUE" else false
			elif self[property] is Array:
				self[property] = dic[property].split(',')
			elif self[property] is Vector2:
				self[property] = Vector2(float(dic[property].split(',')[0]),float(dic[property].split(',')[1]))
			elif not self[property] is String:
				self[property] = str_to_var(dic[property])
			else:
				self[property] = dic[property]

func set_ui(value:Node,ini_args:={})->void:
	UiMap.set_ui(self, value, ini_args)
func remove_ui()->void:
	UiMap.remove_ui(self)
func get_ui():
	return UiMap.get_ui(self)

#region Group
func add_to_mygroup(group_name:Group.group)->void:
	Group.add_to_mygroup(group_name,self)
static func get_first_node_in_group(group_name:Group.group):
	return Group.get_first_node_in_group(group_name)
static func get_nodes_in_group(group_name:Group.group) -> Array:
	return Group.get_nodes_in_group(group_name)
static func clear_group_complete(group_name:Group.group)->void:
	Group.clear_group_complete(group_name)
#endregion
