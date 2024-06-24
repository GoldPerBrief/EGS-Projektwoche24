extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -600.0
const MAX_JUMPS = 2


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var num_jumps = MAX_JUMPS + 1
var score = 0
var highscore = 0

@onready var score_label = $"../CanvasLayer/RichTextLabel"
@onready var scoreboard = $"../CanvasLayer/Scoreboard"
@onready var area_collider = $Area2D

func _ready():
	highscore = get_highest_score()
	update_score_text()

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
	update_highscore_in_csv(score)
	scoreboard.sb_update()
	scoreboard.sb_show()

func collect_stuff(points_amount: int):
	score += points_amount
	update_score_text()
	if score > highscore:
		highscore = score
		update_score_text()
	#print(score)

func get_highest_score() -> int:
	var file
	if (FileAccess.file_exists("user://scores.csv")):
		file = FileAccess.open("user://scores.csv", FileAccess.READ)
	else: 
		file = FileAccess.open("user://scores.csv", FileAccess.WRITE)
		file.store_csv_line(["name","score"])
		file.close()
		file = FileAccess.open("user://scores.csv", FileAccess.READ)
				
	var highest_score = 0
	var line = file.get_csv_line()
	while not file.eof_reached():
		line = file.get_line().strip_edges()
		if line.is_empty():
			continue
		var data = line.split(",")
		var curr_score = int(data[1])
		if curr_score > highest_score:
			highest_score = curr_score
	file.close()
	return highest_score
		
func update_score_text():
	score_label.text = "[b]Highscore:\t%d\nPunkte:\t\t%d\n[/b]" % [highscore, score]
	
func update_highscore_in_csv(new_highscore: int):
	var file = FileAccess.open("user://scores.csv", FileAccess.READ_WRITE)
	while not file.eof_reached():
		file.get_csv_line()
	file.store_csv_line(["John Doe", new_highscore])
	
	
