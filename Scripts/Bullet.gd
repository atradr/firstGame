extends Area2D

export var SPEED = 400

onready var pivot = $"/root/Main/Pivot"
var velocity = Vector2()

func _process(delta):
	position += velocity * delta
	
func init(pos):
	position = pos
	var dir = pivot.position - position
	velocity = dir.normalized() * SPEED

func _on_Visibility_screen_exited():
	queue_free()
