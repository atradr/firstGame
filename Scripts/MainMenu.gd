extends Control

func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	if Input.is_key_pressed(KEY_SPACE):
		get_tree().change_scene("MainScenes/Main.tscn")
		
func _on_StartButton_pressed():
	get_tree().change_scene("MainScenes/Main.tscn")
