extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -600.0
const MAX_JUMPS = 2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var num_jumps = MAX_JUMPS + 1

@onready var area_collider = $Area2D
@onready var animation = $AnimatedSprite2D

func _ready():
	pass

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		num_jumps = 0
	
	for body in area_collider.get_overlapping_bodies():
		if body.has_meta("deadly") and body.get_meta("deadly"):
			sterben()
		elif body.has_meta("is_victory") and body.get_meta("is_victory"):
			gewinnen()
			
	if Input.is_action_just_pressed("ui_accept") and ( is_on_floor() or num_jumps < MAX_JUMPS ):
		velocity.y = JUMP_VELOCITY
		num_jumps += 1
		
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	
	if (velocity.y < 0):
		animation.play("jump_up")
	elif (velocity.y > 0):
		animation.play("fall")
	elif direction < 0:
		animation.play("links")
		animation.flip_h = true
	elif direction > 0:
		animation.play("rechts")
		animation.flip_h = false
	elif (velocity.y == 0) and (direction == 0):
		animation.play("default")
		
	#get_node("Camera2D").position = position
	move_and_slide()

func gewinnen():
	pass

func sterben():
	pass
