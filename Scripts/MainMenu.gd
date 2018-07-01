extends Control

var save_data

func _ready():
	load_game()

func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	if Input.is_key_pressed(KEY_SPACE):
		get_tree().change_scene("MainScenes/Main.tscn")

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://game.save"):
		reset_save()
	save_game.open("user://game.save", File.READ)
	save_data = parse_json(save_game.get_line())
	save_game.close()

func reset_save():
	var sg = File.new()
	sg.open("user://game.save", File.WRITE)
	sg.store_line(to_json(get_default_save_state()))
	sg.close()

func get_default_save_state():
	var data = {
		"highscore" : 0,
		"boss1_kills" : 0,
		"boss2_kills" : 0,
		"boss3_kills" : 0
	}
	return data

func _on_StartButton_pressed():
	get_tree().change_scene("MainScenes/Main.tscn")

func _on_HowToPlayButton_pressed():
	get_tree().change_scene("MainScenes/HowToPlay.tscn")

func _on_ToScores_pressed():
	get_tree().change_scene("MainScenes/Scores.tscn")

func _on_ToCredits_pressed():
	get_tree().change_scene("MainScenes/Credits.tscn")
