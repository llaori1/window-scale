extends Control

class_name RewardMenu

var button_group := ButtonGroup.new()

signal reward_selected()

func _ready() -> void:
	for child in %RewardButtons.get_children(false):
		child.toggle_mode = true
		child.set_button_group(button_group)
	
	button_group.pressed.connect(_on_reward_selected)

func _on_reward_selected(base_button:BaseButton):
	reward_selected.emit(base_button.text)


func set_reward_cards(reward_cards:Array):
	%RewardButtons.get_child(0).text = reward_cards[0]
	%RewardButtons.get_child(1).text = reward_cards[1]
	%RewardButtons.get_child(2).text = reward_cards[2]
