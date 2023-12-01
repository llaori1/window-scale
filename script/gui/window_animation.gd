extends Control

#var last_mouse_pos:Vector2
#var is_rs_resizing:bool = false
#var is_bs_resizing:bool = false
#var is_ts_resizing:bool = false
#var is_ls_resizing:bool = false

@export var window_global_position:Vector2
var is_scaling :bool = false

#var is_mouse_entered:= false

var window_data :WindowData

signal player_changed_size()

const TOLERANCE = 100
const DEAD_ZONE_SIZE = Vector2(10,10)

func _ready() -> void:
	window_data = GlobalResourceLoader.create_window('1')
	window_data.active_area = Rect2(Vector2(100, 100),Vector2(1700, 900))
	window_data.window_global_position = window_global_position
	var new_skill = GlobalResourceLoader.create_skill('sprint')
	new_skill.owner = window_data
	window_data.enemy_skills.append(new_skill)


func _process(delta: float) -> void:
	#_set_anchor(SIDE_TOP,0)
	if is_visible_in_tree():
		display()
		window_data.tick(delta)

func display():

	global_position = window_data.window_global_position
	size = window_data.window_cur_size

