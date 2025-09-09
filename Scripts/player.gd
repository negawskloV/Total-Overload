extends CharacterBody2D


var SPEED = 150
const JUMP_VELOCITY = -400

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var cshape = $CollisionShape2D
@onready var crouch_raycast_left = $CRayCastLeft
@onready var crouch_raycast_right = $CRayCastRight

var is_crouching = false
var stuck_under_object = false

var standing_cshape = preload("res://Resources/player_standing_cshape.tres")
var crouching_cshape = preload("res://Resources/player_crouching_cshape.tres")



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and above_head_is_empty():
		velocity.y = JUMP_VELOCITY


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if Input.is_action_just_pressed("crouch"):
		crouch()
	elif Input.is_action_just_released("crouch"):
		if above_head_is_empty():
			stand()
		else:
			if stuck_under_object != true:
				stuck_under_object = true
				
	if stuck_under_object && above_head_is_empty():
		if !Input.is_action_pressed("crouch"):
			stand()
			stuck_under_object = false
	
	if direction > 0:
		animated_sprite.flip_h = false
		
	elif direction < 0:
		animated_sprite.flip_h = true
		
	if is_on_floor():
		if is_crouching == true:
			if direction == 0:
				animated_sprite.play("crouch idle")
			else:
				animated_sprite.play("crouch walk")
		else:
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func above_head_is_empty() -> bool:
	var result = !crouch_raycast_left.is_colliding() && !crouch_raycast_right.is_colliding()
	return result

func crouch():
	if is_crouching:
		return
	is_crouching = true
	cshape.shape = crouching_cshape
	cshape.position.y = 3
	SPEED = 75
	
func stand():
	if is_crouching == false:
		return
	is_crouching = false
	cshape.shape = standing_cshape
	cshape.position.y = -0.5
	SPEED = 150
	
func death():
	animated_sprite.play("death")
	$".".set_collision_layer_value(2, false)
	await get_tree().create_timer(0.4).timeout
	animated_sprite.pause()
