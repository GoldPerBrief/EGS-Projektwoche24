extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -600.0
const MAX_JUMPS = 2


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var num_jumps = MAX_JUMPS + 1
var score = 0

@onready var area_collider = $Area2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		num_jumps = 0
	
	for body in area_collider.get_overlapping_bodies():
		if body.has_meta("deadly") and body.get_meta("deadly"):
			make_dead()
			
	if Input.is_action_just_pressed("ui_accept") and ( is_on_floor() or num_jumps < MAX_JUMPS ):
		velocity.y = JUMP_VELOCITY
		num_jumps += 1
		
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	get_parent().get_node("Camera2D").position = position
	move_and_slide()

func make_dead():
	queue_free()
	print("u dies. u is bad")
	if score != 0:
		print("but u got loads points tho: ", score)
	else:
		print("u didnt even get any points. u sux.")
	pass

func collect_stuff(points_amount: int):
	score += points_amount
	#print(score)
