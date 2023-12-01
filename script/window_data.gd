extends Base

class_name WindowData

var name :int
const CENTER_POINT = Vector2(950, 550)
const RAND_SEED := [1,2,3,4,5,6,7,8,9]

#const MIN_ACTIVE_AREA := Rect2(Vector2(650, 250),Vector2(600, 600))

var grab_tolerance = 50
var active_area := Rect2(Vector2(100, 100),Vector2(1700, 900))
var init_pos := Vector2(800, 400)
var init_window_size := Vector2(300,300):
	set(val):
		init_window_size = val
		
		
var window_cur_size := init_window_size
## record the position of window
var window_global_position := init_pos

#var enemy_health := 10:set = set_enemy_health

var enemy_skills :Array[SkillData] = []
var skill_names := []
var window_move_speed := 1.0


var enemy_scale_speed :float

var step:float
var direction:int

signal window_reached_endpoint()

signal enemy_resized()

const MAIN_WINDOW = preload("res://scene/main_window.tscn")

var is_fir_tick := true
#func set_enemy_health(value):
	#if value <0:
		#enemy_health = 0
	#else:
		#enemy_health = value
#
#func enemy_got_attack():
	#if player_health != 0:
		#set_enemy_health(enemy_health - 1)



func set_window_global_position(_window_global_position:Vector2, _window_cur_size:Vector2 = window_cur_size):
	if not is_on_border(_window_global_position,_window_cur_size):
		window_global_position = _window_global_position
		return true
	return false

func set_window_size(_window_size:Vector2,side:Side):
	if _window_size.x < init_window_size.x or _window_size.y < init_window_size.y:
		return false
	match side:
		SIDE_LEFT:
			var new_pos = window_global_position - (_window_size - window_cur_size)
			if set_window_global_position(new_pos, _window_size):
				window_cur_size = _window_size
				return true
		SIDE_RIGHT:
			if not is_on_border(window_global_position, _window_size):
				window_cur_size = _window_size
				return true
		SIDE_TOP:
			var new_pos = window_global_position - (_window_size - window_cur_size)
			if set_window_global_position(new_pos, _window_size):
				window_cur_size = _window_size
				return true
		SIDE_BOTTOM:
			if not is_on_border(window_global_position, _window_size):
				window_cur_size = _window_size
				return true
	return false

func set_enemy_scale_speed(_enemy_scale_speed:float):
	enemy_scale_speed = _enemy_scale_speed

func set_enemy_move_speed(_window_move_speed:float):
	window_move_speed = _window_move_speed

static func get_window_data():
	return get_nodes_in_group(Group.group.window_set)

func reset_window(orientation:Orientation):
	if orientation == HORIZONTAL:
		set_window_size(Vector2(init_window_size.x, window_cur_size.y),SIDE_LEFT)
		set_window_global_position(Vector2(active_area.position.x + active_area.size.x/2 - window_cur_size.x/2, window_global_position.y))
	elif orientation == VERTICAL:
		set_window_size(Vector2(window_cur_size.x, init_window_size.y),SIDE_BOTTOM)
		#print(Vector2(window_global_position.x, active_area.position.y + active_area.size.y/2 - window_cur_size.y/2))
		set_window_global_position(Vector2(window_global_position.x, active_area.position.y + active_area.size.y/2 - window_cur_size.y/2))

func enemy_change_size(_window_size:Vector2, side:Side):
	var success = set_window_size(_window_size,side)
	enemy_resized.emit()
	return success



func player_change_size(_window_size:Vector2, side:Side):
	var success = set_window_size(_window_size,side)
	return success

func enemy_tick(delta:float):
	
	##enemy plan what to do
	## scale
	## pick a larger number of dimension
#region scale
	## 修改成特定的限制比例
	var h_size = window_cur_size.x
	var v_size = window_cur_size.y
	
	var orientation := HORIZONTAL
	if h_size > v_size:
		orientation = HORIZONTAL
	elif h_size == v_size:
		orientation = HORIZONTAL if randi() % 2 == 0 else VERTICAL
	else:
		orientation = VERTICAL
		
	var _direction :Side
	match orientation:
		HORIZONTAL:
			_direction = SIDE_LEFT if randi() % 2 == 0 else SIDE_RIGHT
		VERTICAL:
			_direction = SIDE_TOP if randi() % 2 == 0 else SIDE_BOTTOM
	
	var vector := [Vector2.RIGHT, Vector2.DOWN]
	#print(active_area,Rect2(window_global_position, window_cur_size))
	if not enemy_change_size(window_cur_size + vector[_direction % 2] * enemy_scale_speed,_direction) and \
	not enemy_change_size(window_cur_size + vector[_direction % 2] * enemy_scale_speed,(_direction + 2) % 4):
		#print(active_area,Rect2(window_global_position, window_cur_size))
		window_reached_endpoint.emit()
		reset_window(orientation)
#endregion
	## move
	plan_move(delta)
	
	## trigger enemy's skills
	for skill in enemy_skills:
		if not skill.skill_triggered.is_connected(trigger_enemy_skill):
			skill.skill_triggered.connect(trigger_enemy_skill)
		skill.check_skill(delta)
	
func trigger_enemy_skill(method_name:String, args:= []):
	self[method_name].callv(args)
	pass

func my_print(test:String):
	print(test)
	pass

## 计划移动的方向和距离
func plan_move(delta:float):
	var vector = [Vector2.LEFT, Vector2.UP, Vector2.RIGHT, Vector2.DOWN]
	var success := false
	
	if step < 0:
		step = 0
	
	if step == 0:
		seed(RAND_SEED.pick_random())
		direction = randi() % 4
		step = 200
	while not success:
		success =  set_window_global_position(window_global_position + vector[direction] * delta * window_move_speed)
		if not success:
			direction = (direction + 1) % 4
		else:
			step -= delta * window_move_speed


func tick(delta:float) -> void:
	#print(active_area,Rect2(window_global_position, window_cur_size))
	enemy_tick(delta)
	## total level time calculate
	#remaining_time -= delta
	#if remaining_time <= 0:
		#level_finished.emit()
		#remaining_time = total_level_time
	#print(player_health)

func _init(dic:={}) -> void:
	super(dic)
	set_ui(MAIN_WINDOW.instantiate(), {'window_data':self})
func is_on_border(_position:Vector2,_window_size:Vector2):
	if is_rect_in_rect(Rect2(_position,_window_size),active_area):
		return false
	return true
func is_point_in_rect(point:Vector2,rect_pos:Vector2,rect_size:Vector2):
	var br_point:Vector2 = rect_pos+rect_size
	if point.x>rect_pos.x and point.x <br_point.x and \
	point.y>rect_pos.y and point.y <br_point.y:
		return true
	return false
func is_rect_in_rect(rect1:Rect2,rect2:Rect2):
	var point1 = rect1.position
	var point2 = rect1.position + rect1.size
	if is_point_in_rect(point1,rect2.position,rect2.size) and \
		is_point_in_rect(point2,rect2.position,rect2.size):
		return true
	return false
