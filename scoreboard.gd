extends RichTextLabel

@onready var scoreboard = $"../Scoreboard"
@onready var text_input = $"../TextEdit"
@onready var save_button = $"../Save_Button"
@onready var discard_button = $"../Discard_Button"
@onready var message_label = $"../Label"

var username = ""
var score = 0

const BAD_PHRASES_FILE = "res://bad_phrases.txt"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	save_button.connect("pressed", Callable(self, "_on_save_pressed"))
	discard_button.connect("pressed", Callable(self, "_on_discard_pressed"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_score(new_score: int):
	score = new_score
	
func read_scores_from_csv():
	var scores = []
	
	var file = FileAccess.open("user://scores.csv", FileAccess.READ)
	var header = file.get_line()
	
	while !file.eof_reached():
		var line = file.get_line()
		if line != "":
			var parts = line.split(",")
			if parts.size() == 2:
				var name = parts[0]
				var score = parts[1].to_int()
				scores.append([score, name])

	scores.sort_custom(func(a, b): return a[0] > b[0])
	file.close()
		
	return scores



func format_scores(scores):
	var formatted_text = "High Scores:\n\n"
	var i = 0
	for score_data in scores:
		i += 1
		formatted_text += "{0}: {1}\n".format([score_data[1], score_data[0]])
		print(score_data)
		if i > 6:
			break
	return formatted_text

func sb_update():
	var scores = read_scores_from_csv()
	var formatted_scores = format_scores(scores)
	
	$".".text = formatted_scores
	
func sb_show():
	$".".visible = true
	
func sb_hide():
	$".".visible = false

func _on_save_pressed():
	var user_text = text_input.text.strip_edges()
	if user_text.is_empty():
		message_label.text = "Bitte Namen eingeben!"
		return
	
	#var bad_phrases = load_bad_phrases()
	
	#if contains_bad_phrase(user_text, bad_phrases):
		#message_label.text = "Bitte Eingabe revisieren, da diese verbotene Worte enthält!"
		#return
		
	username = user_text
	
	text_input.text = ""
	message_label.text = "Punktestand gesichtert!"
	update_highscore_in_csv(score)
	scoreboard.sb_update()
	set_visibility_for_all(false)
	scoreboard.sb_show()
	
func _on_discard_pressed():
	text_input.text = ""
	message_label.text = "Punktestand nicht gesichert!"
	scoreboard.sb_update()
	set_visibility_for_all(false)
	scoreboard.sb_show()
	
func load_bad_phrases() -> Array:
	var bad_phrases = []
	var file = FileAccess.open(BAD_PHRASES_FILE, FileAccess.READ)
	if OK:
		while !file.eof_reached():
			var line = file.get_line().strip_edges()
			if not line.is_empty():
				bad_phrases.append(line)
		file.close()
		
	return bad_phrases
	
func contains_bad_phrase(text: String, bad_phrases: Array) -> bool:
	for phrase in bad_phrases:
		if text.find(phrase, 0) != -1:
			return true
	return false
	
func update_highscore_in_csv(new_highscore: int):
	var file = FileAccess.open("user://scores.csv", FileAccess.READ_WRITE)
	while not file.eof_reached():
		file.get_csv_line()
	file.store_csv_line([username, new_highscore])
	

func set_visibility_for_all(is_visible: bool):
	text_input.visible = is_visible
	save_button.visible = is_visible
	discard_button.visible = is_visible
	message_label.visible = is_visible
	
