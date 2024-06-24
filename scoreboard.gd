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
	
	# Read each subsequent line (which contains name,score)
	while !file.eof_reached():
		var line = file.get_line()
		if line != "":
			var parts = line.split(",")
			if parts.size() == 2:
				var name = parts[0]
				var score = parts[1].to_int()
				scores.append({"name": name, "score": score})
		
		file.close()
		
	return scores

func format_scores(scores):
	var formatted_text = "Hign Scores:\n\n"
	
	for score_data in scores:
		formatted_text += "{0}: {1}\n".format(score_data["name"], score_data["score"])
	return formatted_text

func sb_update():
	var scores = read_scores_from_csv()
	var formatted_scores = format_scores(scores)
	
	$".".text = formatted_scores
	
func sb_show():
	$".".visible = true
	
func sb_hide():
	$".".visible = false
