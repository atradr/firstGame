extends Node

var save_data

func _ready():
	load_game()
	set_scores()

func load_game():
	var save_game = File.new()
	save_game.open("user://game.save", File.READ)
	save_data = parse_json(save_game.get_line())
	save_game.close()

func set_scores():
	$HighScore.text = "HIGH SCORE\n" + str(save_data["highscore"])
	$Boss1.text = "DASH BOSS KILLS\n" + str(save_data["boss1_kills"])
	$Boss2.text = "LASER BOSS KILLS\n" + str(save_data["boss2_kills"])
	$Boss3.text = "SPIRAL BOSS KILLS\n" + str(save_data["boss3_kills"])

func _on_ToMenu_pressed():
	get_tree().change_scene("MainScenes/MainMenu.tscn")
