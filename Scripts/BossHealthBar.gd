extends Node2D

var prog_animated_scale = 0
var outline_animated_scale = 0

func init():
	# Want it to fill up at the same speed then slow at the end.
	$Tween.interpolate_property(self, "prog_animated_scale", 0, 480, 2.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "outline_animated_scale", 0, 480, 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
	
func _process(delta):
	$Outline.scale = Vector2(outline_animated_scale, 64)
	$Background.scale = Vector2(outline_animated_scale - 5, 59)
	update_scale(prog_animated_scale)
	
func update_scale(new_scale):
	$Progress.scale = Vector2(new_scale, 59)
