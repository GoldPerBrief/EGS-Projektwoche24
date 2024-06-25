extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const MAX_JUMPS = 2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var num_jumps = MAX_JUMPS + 1
var score = 0

@onready var area = $Area2D

func _ready():
	pass


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		num_jumps = 0
		
	# Handle jump.
	if Input.is_action_just_pressed("move_jump") and ( is_on_floor() or num_jumps < MAX_JUMPS):
		velocity.y += JUMP_VELOCITY
		num_jumps += 1
		
	for body in area.get_overlapping_bodies():
		if body.has_meta("tod") and body.get_meta("tod"):
			sterben()
		elif body.has_meta("sieg") and body.get_meta("sieg"):
			sieg()
		elif body.has_meta("sammeln") and body.has_meta("punkte") and body.get_meta("sammeln"):
			einsammeln(body)
			

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func sieg():
	pass

func sterben():
	pass
	
func einsammeln(body):
	var punkte = body.get_meta("punkte")
	score += punkte
	#scoretext.aktualisieren()
	
