extends "Boss.gd"

export (PackedScene) var Laser

var spawn_speed = 35

var velocity
var direction = 1
var speed = 400

var moving = false
var target
var cd_time = 0.9

func _ready():
	show()
	position = Vector2(rand_range(200, 350), -150)
	# ~(200, -80) when it finishes spawning.
	
func _process(delta):
	if died:
		return
	if health < 0:
		emit_signal("enemy_died", self)
		died = true
		shrink()
		
	var health_ratio = float(health) / max_health
	if !spawning:
		health_bar.update_scale(475 * health_ratio)
		
	if spawning:
		velocity = Vector2(0, 1) * spawn_speed
	elif moving:
		if position.x > screen_size.x or position.x < 0:
			position.x = clamp(position.x, 0, screen_size.x)
			direction *= -1
		velocity = Vector2(direction, 0) * speed
		
	position += velocity * delta

func shoot():
	var l = Laser.instance()
	add_child(l)
	camera.shake(0.5, 27, 16)

func _on_SpawnTimer_timeout():
	spawning = false
	moving = true
	$AttackTimer.start()
	$BlinkTimer.start()
	
func _on_BlinkTimer_timeout():
	if danger_on:
		$Sprite.modulate = danger_color
		$Nozzle.modulate = danger_color
		danger_on = false
	else:
		$Sprite.modulate = default_color
		$Nozzle.modulate = default_color
		danger_on = true

func _on_AttackTimer_timeout():
	if died:
		return
	shoot()
	$BlinkTimer.stop()
	$Sprite.modulate = default_color
	$Nozzle.modulate = default_color
	$ShootingTimer.start()

func _on_CooldownTimer_timeout():
	$AttackTimer.start()
	$BlinkTimer.start()

func _on_ShootBoss_area_entered( area ):
	if !spawning:
		if area.is_in_group("bullets"):
			health -= 1
			speed += 1
			cd_time -= .001
			area.hit(self)

func _on_ShootingTimer_timeout():
	$CooldownTimer.wait_time = cd_time
	$CooldownTimer.start()
