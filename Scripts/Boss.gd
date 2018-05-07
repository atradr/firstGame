extends Area2D

export (float) var max_health = 300
export (int) var points = 10

signal enemy_died(enemy)

onready var health_bar = $"/root/Main/BossHealthBar"

var player

var scale_to_pixel = 64

var health = max_health
var spawning = true

var screen_size

func _ready():
	hide()
	player = $"/root/Main".get_player()
	screen_size = get_viewport().size

func init():
	$SpawnTimer.start()