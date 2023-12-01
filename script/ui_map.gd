extends Node

## ui pool   id->ui instance
@export var map:Dictionary
func set_ui(key:Variant,value:Node,ini_args:={})->void:
	## 初始化数据
	if not ini_args=={}:
		for arg in ini_args:
			value[arg] = ini_args[arg]
	## 绑定关系
	if map.has(key) and map[key] != null:
		return
	else:
		map[key] = value
## 会把ui彻底queue free
func remove_ui(key:Variant)->void:
	if map.has(key):
		map[key].queue_free()
func get_ui(key:Variant):
	if map.has(key):
		return map[key]
	else:
		return null
