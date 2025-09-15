extends Area2D

@onready var game_manager: Node = $"/root/Game/GameManager"


func _on_body_entered(_body):
	game_manager.player_death()

func shot():
	var parent = get_parent()
	print("i got shot")
	parent.shot()
