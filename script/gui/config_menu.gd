extends Control

class_name ConfigMenu

var game:Game

@export var music:Regulator

signal quit_game
signal start_game
signal restart_level
signal restart_game
signal music_changed


func change_music(value):
	if game!=null:
		if not music_changed.is_connected(game.set_music_volume):
			music_changed.connect(game.set_music_volume)
	music_changed.emit(music.get_value())



func _on_quit_pressed() -> void:
	if game!=null:
		if not quit_game.is_connected(game.quit_game):
			quit_game.connect(game.quit_game)
	quit_game.emit()
	pass # Replace with function body.

func _on_resume_pressed() -> void:
	if game!=null:
		if not start_game.is_connected(game.start_game):
			start_game.connect(game.start_game)
	start_game.emit()
	pass # Replace with function body.
	
func _on_restart_pressed() -> void:
	if game!=null:
		if not restart_level.is_connected(game.restart_level):
			restart_level.connect(game.restart_level)
	restart_level.emit()
	pass # Replace with function body.
	
func _on_visibility_changed() -> void:
	if game != null:
		music.set_value(game.get_music_volume())
	pass # Replace with function body.
	
func _ready() -> void:
	music.value_changed.connect(change_music)
	music.name_label = 'Music'


