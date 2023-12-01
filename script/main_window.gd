extends Control


@onready var enemy_info: GridContainer = %EnemyInfo

var last_mouse_pos:Vector2
var is_rs_resizing:bool = false
var is_bs_resizing:bool = false
var is_ts_resizing:bool = false
var is_ls_resizing:bool = false

var ts_detect_size

var bs_detect_size

var ls_detect_size

var rs_detect_size

var ts_box:Rect2
var bs_box:Rect2
var ls_box:Rect2
var rs_box:Rect2


var is_scaling :bool = false

var is_mouse_entered := false

var window_data :WindowData

signal player_changed_size()

var tolerance = 100

var mouse_shape := CURSOR_HSIZE

const DEAD_ZONE_SIZE = Vector2(10,10)

func _ready() -> void:
	if window_data != null:
		player_changed_size.connect(window_data.player_change_size)
	

func _process(delta: float) -> void:
	#_set_anchor(SIDE_TOP,0)
	display()
	
func display():
	if window_data != null:
		#enemy_info.get_child(0).text = 'ENEMY_HEALTH: ' + str(window_data.enemy_health)
		#enemy_info.get_child(1).text = 'WINDOW_SCALE_RATIO: ' + str(snapped(window_data.window_cur_size.x / window_data.window_cur_size.y, 0.1))
		#enemy_info.get_child(2).text = 'SCALE_LIMIT: ' + str(window_data.player_max_scale_get_attack)
		#enemy_info.get_child(3).text = 'SCALE_SPEED: ' + str(window_data.enemy_scale_speed)
		#enemy_info.get_child(4).text = 'MOVE_SPEED: ' + str(window_data.window_move_speed)
		
		#enemy_info.get_child(5).text = 'PLAYER_HEALTH: ' + str(window_data.player_health)
		#enemy_info.get_child(6).text = 'TIME_LIMIT: ' + str(window_data.player_time_limit_to_scale)
		pass
	
	
	
	#print(mouse_shape)
	#pivot_offset = window_data.window_pivot_offset
	#scale = window_data.window_cur_scale
	global_position = window_data.window_global_position
	size = window_data.window_cur_size
	tolerance = window_data.grab_tolerance
	%Left.position = ls_box.position
	%Left.size = ls_box.size
	
	%Top.position = ts_box.position
	%Top.size = ts_box.size
	
	%Right.position = rs_box.position
	%Right.size = rs_box.size
	
	%Down.position = bs_box.position
	%Down.size = bs_box.size

func get_dragging_side() -> Side:
#var is_rs_resizing:bool = false
#var is_bs_resizing:bool = false
#var is_ts_resizing:bool = false
#var is_ls_resizing:bool = false
	return [is_ls_resizing, is_ts_resizing, is_rs_resizing, is_bs_resizing].find(true)


func _input(event: InputEvent) -> void:
	
	ts_detect_size = Vector2(size.x * scale.x - DEAD_ZONE_SIZE.x * 2, tolerance)
	
	bs_detect_size = Vector2(size.x * scale.x - DEAD_ZONE_SIZE.x * 2,tolerance)
	
	ls_detect_size = Vector2(tolerance, size.y * scale.y - DEAD_ZONE_SIZE.y * 2)
	
	rs_detect_size = Vector2(tolerance, size.y * scale.y - DEAD_ZONE_SIZE.y * 2)
	
	ts_box = Rect2(Vector2(DEAD_ZONE_SIZE.x, - ts_detect_size.y / 2),ts_detect_size)
	rs_box = Rect2(Vector2(size.x * scale.x - rs_detect_size.x / 2, DEAD_ZONE_SIZE.y),rs_detect_size)
	ls_box = Rect2(Vector2( - ls_detect_size.x / 2, DEAD_ZONE_SIZE.y),ls_detect_size)
	bs_box = Rect2(Vector2(DEAD_ZONE_SIZE.x, size.y * scale.y - bs_detect_size.y / 2),bs_detect_size)
	
	#print(ts_box)
	#print(global_position)
	if Input.is_action_just_released("lmb"):
		reset_mouse()
	#if not is_rs_resizing and not is_bs_resizing and not is_ts_resizing and not is_ls_resizing:
		
		
	if is_rs_resizing:
		var mouse_offset = get_global_mouse_position()-last_mouse_pos
		player_changed_size.emit(window_data.window_cur_size + Vector2(mouse_offset.x,0),SIDE_RIGHT)
		
	elif is_bs_resizing:
		var mouse_offset = get_global_mouse_position()-last_mouse_pos
		player_changed_size.emit(window_data.window_cur_size + Vector2(0,mouse_offset.y),SIDE_BOTTOM)
		
	elif is_ls_resizing:
		var mouse_offset = get_global_mouse_position()-last_mouse_pos
		player_changed_size.emit(window_data.window_cur_size + Vector2( - mouse_offset.x,0),SIDE_LEFT)
		
	elif is_ts_resizing:
		var mouse_offset = get_global_mouse_position()-last_mouse_pos
		player_changed_size.emit(window_data.window_cur_size + Vector2(0,- mouse_offset.y),SIDE_TOP)
	var is_in_ls_box = is_point_in_the_rect(get_global_mouse_position(), global_position + ls_box.position, ls_box.size)
	var is_in_ts_box = is_point_in_the_rect(get_global_mouse_position(), global_position + ts_box.position, ts_box.size)
	var is_in_rs_box = is_point_in_the_rect(get_global_mouse_position(), global_position + rs_box.position, rs_box.size)
	var is_in_bs_box = is_point_in_the_rect(get_global_mouse_position(), global_position + bs_box.position, bs_box.size)
	
	for child in %Grabber.get_children(false):
		child.mouse_default_cursor_shape = mouse_shape
	#mouse_default_cursor_shape = mouse_shape
	#print([is_in_ls_box, is_in_ts_box, is_in_rs_box, is_in_bs_box])
	#
	#print(mouse_default_cursor_shape)
	if not is_scaling and is_mouse_entered and is_point_in_the_rect(get_global_mouse_position(), global_position + ls_box.position, ls_box.size):
		mouse_shape = CURSOR_HSIZE
		if Input.is_action_just_pressed("lmb"):
			is_ls_resizing = true
			is_bs_resizing = false
			is_rs_resizing = false
			is_ts_resizing = false
			
			is_scaling = true
	elif not is_scaling and is_mouse_entered and is_point_in_the_rect(get_global_mouse_position(), global_position +ts_box.position, ts_box.size):
		mouse_shape  = CURSOR_VSIZE
		if Input.is_action_just_pressed("lmb"):
			is_ts_resizing = true
			is_ls_resizing = false
			is_bs_resizing = false
			is_rs_resizing = false
			
			is_scaling = true
			#accept_event()
	elif not is_scaling and is_mouse_entered and is_point_in_the_rect(get_global_mouse_position(), global_position + rs_box.position, rs_box.size):
		mouse_shape  = CURSOR_HSIZE
		#print(window_data)
		if Input.is_action_just_pressed("lmb"):
			is_rs_resizing = true
			is_bs_resizing = false
			is_ts_resizing = false
			is_ls_resizing = false

			is_scaling = true
			
			#accept_event()
	elif not is_scaling and is_mouse_entered and is_point_in_the_rect(get_global_mouse_position(), global_position + bs_box.position, bs_box.size):
		mouse_shape  = CURSOR_VSIZE
		if Input.is_action_just_pressed("lmb"):
			is_bs_resizing = true
			is_rs_resizing = false
			is_ts_resizing = false
			is_ls_resizing = false
			
			is_scaling = true
			#accept_event()

			#accept_event()

	last_mouse_pos = get_global_mouse_position()

func is_point_in_the_rect(point:Vector2,tl_point:Vector2,rect_size:Vector2):
	var br_point:Vector2 = tl_point+rect_size
	if point.x>tl_point.x and point.x <br_point.x and \
	point.y>tl_point.y and point.y <br_point.y:
		return true
	return false

	#print('mouse_left')
	pass # Replace with function body.

#func _draw() -> void:
	##draw_rect(Rect2(Vector2(200,200), Vector2(300,300)), Color.WHITE)
	#draw_rect(ts_box, Color.WHITE)
	#draw_rect(ls_box, Color.WHITE)
	#draw_rect(rs_box, Color.WHITE)
	#draw_rect(bs_box, Color.WHITE)
	#print('draw: ' + str(ts_box))

func reset_mouse():
	is_rs_resizing = false
	is_bs_resizing = false
	is_ts_resizing = false
	is_ls_resizing = false
	
	is_scaling = false
	mouse_default_cursor_shape = CURSOR_ARROW
	
	#print('reset')

func _on_grabber_mouse_entered() -> void:
	is_mouse_entered = true
	pass # Replace with function body.


func _on_grabber_mouse_exited() -> void:
	if not is_scaling:
		reset_mouse()
	is_mouse_entered = false
	#print('exited')
	pass # Replace with function body.
