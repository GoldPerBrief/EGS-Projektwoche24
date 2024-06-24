extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
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
