extends Area2D

export var SPEED = 400

onready var pivot = $"../Pivot"
var velocity = Vector2()

func _process(delta):
	position += velocity * delta
	
func init(pos):
	position = pos
	var dir = pivot.position - position
	velocity = dir.normalized() * SPEED

func _on_Visibility_screen_exited():
	queue_free()

func hit(area):
	if (area.is_in_group("bosses")):
		queue_free()

# This is a result of my terrible code
func _on_Bullet_area_entered( area ):
	if area.is_in_group("outside_area"):
		queue_free()
		area.get_parent().get_parent().take_damage()
