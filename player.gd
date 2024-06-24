extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -600.0
const MAX_JUMPS = 2


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var num_jumps = MAX_JUMPS + 1


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		num_jumps = 0
	
	if Input.is_action_just_pressed("ui_accept") and ( is_on_floor() or num_jumps < MAX_JUMPS ):
		velocity.y = JUMP_VELOCITY
		num_jumps += 1
		
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()

func collect_stuff(stuff):
	print_debug(stuff)
