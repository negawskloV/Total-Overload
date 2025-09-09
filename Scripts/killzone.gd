extends Area2D

@onready var game_manager: Node = $"/root/Game/GameManager"


func _on_body_entered(body):
	game_manager.player_death()
