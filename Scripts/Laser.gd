extends Area2D

export (float) var speed = 1500

var player

func _process(delta):
	var velocity = Vector2(0, speed)
	position += velocity * delta

func _on_Laser_area_entered( area ):
	if area.get_name() == "Player":
		area.hit(self)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
