extends Node

func _ready():
	var OS_name = OS.get_name()
	if OS_name == "Android" or OS_name == "iOS":
		$GUI/Instructions.text = "TOUCH THE SCREEN TO CREATE A VIRTUAL JOYSTICK TO MOVE, TAP ANYWHERE WITH ANOTHER FINGER TO DASH IN YOUR CURRENT DIRECTION\n\nYOU ALWAYS SHOOT THROUGH THE CENTER PIVOT POINT\n\nDODGE PAST ENEMIES AND HERD THEM INTO YOUR BULLET STREAM"

func _on_ToMenu_pressed():
	get_tree().change_scene("MainScenes/MainMenu.tscn")
