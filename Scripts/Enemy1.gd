extends Area2D

export (float) var speed = 300
export (int) var health = 12
export (Vector2) var scale_decrease = Vector2(.05, .05)
export (int) var points = 1

signal enemy_died(enemy)

onready var player = $"/root/Main/Player"

var spawning = true
var fleeing = false
var direction
var velocity
var spawn_speed = 35
var spawn_time = 1.5


var y_choices
var screen_width

func _ready():
	var size = get_viewport().size
	y_choices = [-32, size.y + 32]
	screen_width = size.x

func _process(delta):
	if health < 0:
		emit_signal("enemy_died", self)
		queue_free()
		
	if spawning:
		velocity = Vector2(0, direction)
		velocity = velocity.normalized() * spawn_speed
	else:
		velocity = player.position - position
		velocity = velocity.normalized() * speed
		if fleeing:
			velocity = -velocity
		rotation = atan2(player.position.x - position.x, position.y - player.position.y)
	position += velocity * delta

func init():
	var x = rand_range(0, screen_width)
	var choice = randi() % 2
	var y = y_choices[choice]
	
	position = Vector2(x, y)
	direction = pow(-1, choice)
	$SpawnTimer.wait_time = spawn_time
	$SpawnTimer.start()

func _on_SpawnTimer_timeout():
	spawning = false
	
func _on_Enemy1_area_entered( area ):
	if !spawning and !fleeing:
		if area.is_in_group("bullets"):
			health -= 1
			scale -= scale_decrease
			area.hit(self)
		if area.get_name() == "Player":
			area.hit(self)
