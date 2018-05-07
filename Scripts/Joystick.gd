extends Position2D

var active = false

var stick_width = 3

func _ready():
	hide()

func _process(delta):
	if active: 
		var location = $Location.position
		# original logic, just equal to difference
		#$Circle.position = location - position
		var difference = location - position
		if difference.length() > 100:
			difference = difference.normalized() * 100
		$Circle.position = difference
		$Stick.scale = Vector2(difference.length(), stick_width)
		$Stick.position = difference / 2
		$Stick.rotation = difference.angle()

func activate(pos):
	position = pos
	active = true
	show()

func deactivate():
	active = false
	hide()
	
func set_location(pos):
	$Location.position = pos