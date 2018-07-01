extends AudioStreamPlayer

func _ready():
	var song = load("res://assets/mainTrack.wav")
	set_stream(song)
	play()
