extends Control

class_name MainMenu

var game: Game

signal quit_game
signal start_game
signal music_changed

@export var music:Regulator

func change_music(value):
	if game!=null:
		if not music_changed.is_connected(game.set_music_volume):
			music_changed.connect(game.set_music_volume)
	music_changed.emit(value)




func _on_config_pressed() -> void:
	%Config.show()
	%Main.hide()


func _on_back_pressed() -> void:
	%Config.hide()
	%Main.show()


func _on_quit_pressed() -> void:
	if game!=null:
		if not quit_game.is_connected(game.quit_game):
			quit_game.connect(game.quit_game)
	quit_game.emit()


func _on_start_pressed() -> void:
	if game!=null:
		if not start_game.is_connected(game.start_game):
			start_game.connect(game.start_game)
	start_game.emit()


func _on_visibility_changed() -> void:
	if game != null:
		music.set_value(game.get_music_volume())



func _ready() -> void:
	music.value_changed.connect(change_music)
	music.name_label = 'Music'
	

