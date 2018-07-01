extends Area2D

export (float) var max_health = 300
export (int) var points = 10

signal enemy_died(enemy)

onready var health_bar = $"/root/Main/BossHealthBar"
onready var camera = $"../Camera"

onready var default_color = $Sprite.modulate
var danger_color = Color(1.0, .082, .075)
var danger_on = false

onready var player = $"/root/Main/Player"

var scale_to_pixel = 64

var health = max_health
var spawning = true
var died = false

var screen_size

func _ready():
	hide()
	screen_size = get_viewport().size

func init():
	$SpawnTimer.start()

# The amount of magic numbers in this function hurts my soul
func shrink():
	yield(get_tree().create_timer(1), "timeout")
	while (scale.x > .05):
		scale -= Vector2(.01 + scale.x/10, .01 + scale.x/10)
		yield(get_tree().create_timer(1/float(200) * sqrt(scale.x)), "timeout")
	queue_free()