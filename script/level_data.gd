extends Base

class_name LevelData
var name :int

var player_health := 3:set = set_player_health

var active_area := Rect2(Vector2(100, 100),Vector2(1700, 900))

var window_numbers := 1

var window_names := []

var window_data_arr := []

var total_level_time :float :
	set(val):
		total_level_time = val
		remaining_time = val
var remaining_time :float

var is_fir_tick: = true


#signal window_reached_endpoint()
signal level_finished()
signal player_died()


func set_player_health(value):
	if value <0:
		player_health = 0
	else:
		player_health = value


func player_got_attack():
	set_player_health(player_health - 1)



static func get_level_data() -> LevelData:
	var level_data = get_nodes_in_group(Group.group.level_set)
	if not level_data.is_empty():
		return get_nodes_in_group(Group.group.level_set)[0]
	return null

func get_active_area() -> Rect2:
	return active_area

func tick(delta:float) -> void:
	## fix parameters when first run tick function
	if is_fir_tick:
		is_fir_tick = false
		window_data_arr = WindowData.get_window_data()
		
		var _pos := Vector2(800, 400)
		
		#var fixed_paramter = FixedParameter.fixed_paramter
		for window_data in window_data_arr:
			if not window_data.window_reached_endpoint.is_connected(_on_window_reached_endpoint):
				window_data.window_reached_endpoint.connect(_on_window_reached_endpoint)
			window_data.window_global_position = _pos
			_pos += Vector2(50,50)
			#for para in fixed_paramter:
				#if para in window_data:
					#if window_data[para] is Rect2:
						#window_data[para].position += fixed_paramter[para].position
						#window_data[para].size += fixed_paramter[para].size
					#else:
						#window_data[para] += fixed_paramter[para]
	
	for window in WindowData.get_window_data():
		window.tick(delta)
	if player_health <= 0:
		player_health = 3
		player_died.emit()

func _on_window_reached_endpoint():
	player_got_attack()
	#window_reached_endpoint.emit()

func _init(dic:={}) -> void:
	super(dic)

