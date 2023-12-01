extends Node



var fixed_paramter := {
	#'active_area':Rect2(Vector2.ZERO, Vector2.ZERO),
	'grab_tolerance':0,
	'grab_efficiency':0,
	'init_window_size':Vector2.ZERO,
	'enemy_scale_speed':0,
	'total_level_time':0,
	'window_numbers':0,
	'player_health':0,
	}

var fixed_dic := {
	#'Increase 10% window activity range':['active_area', 0.1],
	#'Increase 20% window activity range':['active_area', 0.1],
	'Decrease initial window size':['init_window_size', 0.1],
	"Increase the size of the window's graspable edges":['grab_tolerance', 0.1],
	"Increase the movement distance of the grabbing window":['grab_efficiency', 0.1],
	'Decrease window expansion speed':['enemy_scale_speed', 0.1],
	'Decrease level total time':['total_level_time', 0.1],
	'Decrease number of windows ':['window_numbers', 1],
	'Increase player health':['player_health', 1],
}
