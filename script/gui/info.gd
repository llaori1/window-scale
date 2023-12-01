extends Control

class_name InfoPanel

signal tip_confirmed

func _ready() -> void:
	%Button.pressed.connect(_on_tip_confirmed)
	pass
func _on_tip_confirmed():
	tip_confirmed.emit()
	pass

func _on_player_died():
	%Text.text = 'YOU DIED, TRY AGAIN'
	pass

func _on_player_win_level():
	%Text.text = 'YOU WIN, GO TO NEXT LEVEL'
	pass
func _on_player_win_game():
	%Text.text = 'YOU WIN !!'
	pass
