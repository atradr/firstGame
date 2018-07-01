extends Node


func _on_ToMenu_pressed():
	get_tree().change_scene("MainScenes/MainMenu.tscn")

func _on_HowToPlayButton_pressed():
	OS.shell_open("https://twitter.com/austintradr")
