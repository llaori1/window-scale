extends Control

class_name Game
@onready var music_player: AudioStreamPlayer = $Music
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var main_canvas: CanvasLayer = $MainCanvas
@onready var gui: CanvasLayer = $GUI

@export var main_menu: MainMenu
@export var config_menu: ConfigMenu
@export var info_panel: InfoPanel

var music_volume:float = 50


var is_tick := false

var level_data :LevelData

var timer := Timer.new()

var is_fir_game := true

func _ready() -> void:
	main_menu.game = self
	config_menu.game = self
	init_level()
	animation_player.play("BackGround")


func _process(delta: float) -> void:
	if is_tick:
		level_data.tick(delta)
		level_data.remaining_time = timer.time_left
	#%Info.get_child(0).text = 'MOUSE_POS:' + str(get_global_mouse_position())
	#%Info.get_child(1).text = 'FPS:' + str(Engine.get_frames_per_second())
	%Info.get_child(2).text = 'Level:' + str(level_data.name)
	%Info.get_child(3).text = 'Health: ' + str(level_data.player_health)
	%Info.get_child(4).text = 'Remaining Time: ' + str(snapped(timer.time_left,1))


func free_level():
	for child in main_canvas.get_children(false):
		child.queue_free()
	await get_tree().create_timer(1).timeout


func restart_level():
	timer.stop()
	await free_level()
	GlobalResourceLoader.load_level(GlobalResourceLoader.CUR_LEVEL)
	init_level()
	start_game()


func next_level():
	if level_data.name == 10:
		_on_player_win_game()
	timer.stop()
	await free_level()
	GlobalResourceLoader.load_level(GlobalResourceLoader.NEXT_LEVEL)
	init_level()
	start_game()


func init_level():
	
	level_data = LevelData.get_level_data()
	for window_data in WindowData.get_window_data():
		main_canvas.add_child(window_data.get_ui())
	
	## level finished signal
	timer.stop()
	timer.wait_time = level_data.total_level_time
	if not timer.timeout.is_connected(_on_player_win_level):
		timer.timeout.connect(_on_player_win_level)
	if timer.get_parent() != self:
		add_child(timer)
	
	level_data.player_died.connect(_on_player_died)
	%ActiveArea.position = level_data.get_active_area().position
	%ActiveArea.size = level_data.get_active_area().size
	

func quit_game():
	get_tree().quit()


func start_game():
	main_menu.hide()
	config_menu.hide()
	%BackGroundAnimation.hide()
	if is_fir_game:
		await confirm_info()
		is_fir_game = false
	
	is_tick = true
	play_music()
	if timer.paused:
		timer.paused = false
	else:
		timer.start()



func pause_game():
	#main_menu.show()
	is_tick = false
	set_music(false)
	timer.paused = true

func confirm_info():
	info_panel.show()
	await info_panel.tip_confirmed
	info_panel.hide()
	
func config():
	config_menu.show()
	%BackGroundAnimation.show()
	pause_game()
	#config_menu.show()


func play_music():
	if music_player.has_stream_playback():
		music_player.play(music_player.get_playback_position())
	else:
		music_player.play()
	var volume_db = remap(music_volume, 0, 100, -20, 0)
	if volume_db == -20:
		volume_db = -80
	music_player.volume_db = volume_db


func set_music(flag:bool):
	#music_player.stop()
	music_player.stream_paused = flag



func get_music_volume():
	return music_volume
func set_music_volume(val:float):
	music_volume = val



func _input(event: InputEvent) -> void:
	if is_tick:
		if Input.is_action_just_pressed('ESC'):
			config()
	if Input.is_action_just_pressed("Pause"):
		is_tick = !is_tick
		set_music(!is_tick)
		timer.paused = !is_tick
		

func _on_player_died():
	pause_game()
	info_panel._on_player_died()
	await confirm_info()
	await restart_level()
	start_game()
	pass

func _on_player_win_level():
	pause_game()
	info_panel._on_player_win_level()
	await confirm_info()
	await next_level()
	start_game()
	pass

func _on_player_win_game():
	info_panel._on_player_win_game()
	await confirm_info()
	quit_game()
	pass



func _on_restart_pressed() -> void:
	await restart_level()


func _on_next_level_pressed() -> void:
	await next_level()

