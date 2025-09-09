extends Node2D

@onready var raycast_left: RayCast2D = $RayCastLeft
@onready var raycast_right: RayCast2D = $RayCastRight
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast_up: RayCast2D = $RayCastUp
@onready var raycast_up2: RayCast2D = $RayCastUp2
@onready var raycast_up3: RayCast2D = $RayCastUp3
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var player: CharacterBody2D = $"../Player"
@onready var game_manager: Node = %GameManager
@onready var killzone: Area2D = $Killzone

var direction = 1
var dead = false
const SPEED = 60

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if raycast_up.is_colliding() or raycast_up2.is_colliding() or raycast_up3.is_colliding():
		killzone.set_collision_mask_value(2, false)
		raycast_up.set_collision_mask_value(2, false)
		raycast_up2.set_collision_mask_value(2, false)
		raycast_up3.set_collision_mask_value(2, false)
		dead = true
		game_manager.add_point()
		player.velocity.y = -200
		direction = 0
		audio_stream_player_2d.play()
		await get_tree().create_timer(1).timeout
		queue_free()
	
	if raycast_left.is_colliding():
		direction = 1
	if raycast_right.is_colliding():
		direction = -1
	position.x += direction * SPEED * delta
	
	if direction > 0:
		animated_sprite.flip_h = false
		
	elif direction < 0:
		animated_sprite.flip_h = true
	
	if dead:
		animated_sprite.play("death")	
	else:
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("roll")
