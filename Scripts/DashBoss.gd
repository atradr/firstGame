extends "Boss.gd"

var default_scale = 3
var spawn_scale = 16
var spawn_scale_decrease = Vector2(8, 8)

var dash_speed = 1800 # 2100-2400 is good for a harder difficulty
var direction

var dropping = false
var dashing = false

func _process(delta):
	if died:
		return
	if health < 0:
		emit_signal("enemy_died", self)
		died = true
		shrink()
		
	var health_ratio = float(health) / max_health
	if !dropping and !spawning:
		health_bar.update_scale(475 * health_ratio)
		# Scale based on 3^(-x+1) from (0, 0.5) according to remaining health.
		var new_scale = pow(3, -(float(max_health) - health) / (2 * max_health) + 1)
		scale = Vector2(new_scale, new_scale)
		if health_ratio > 0:
			$AttackCooldownTimer.wait_time = .5 * (health_ratio * health_ratio) + .5
			$ChargeTimer.wait_time = .5 * (health_ratio * health_ratio) + .5
	
		
	if dropping:
		# Scales down faster as it gets smaller
		scale -= spawn_scale_decrease * delta * (spawn_scale - scale.x + 2)
		if scale.x < default_scale:
			stop_spawn()
	elif dashing:
		var velocity = direction.normalized() * dash_speed
		position += velocity * delta
		var w = scale.x * scale_to_pixel
		var h = scale.y * scale_to_pixel
		if position.x != clamp(position.x, w / 2, screen_size.x - w / 2) or position.y != clamp(position.y, h / 2, screen_size.y - h / 2):
			dashing = false
			$AttackCooldownTimer.start()
			camera.shake(0.5, 27, 16)
		position.x = clamp(position.x, w / 2, screen_size.x - w / 2)
		position.y = clamp(position.y, h / 2, screen_size.y - h / 2)

func stop_spawn():
	spawning = false
	dropping = false
	scale = Vector2(default_scale, default_scale)
	camera.shake(0.5, 27, 16)
	$AttackCooldownTimer.start()

func _on_SpawnTimer_timeout():
	show()
	dropping = true
	var offset = scale.x * scale_to_pixel
	var spawn_x = 192
	var spawn_y = rand_range(offset, screen_size.y - offset)
	position = Vector2(spawn_x, spawn_y)
	scale = Vector2(spawn_scale, spawn_scale)

func _on_BlinkTimer_timeout():
	if danger_on:
		$Sprite.modulate = danger_color
		danger_on = false
	else:
		$Sprite.modulate = default_color
		danger_on = true

# Times between cooldown and when the boss starts moving. Blinking during.
func _on_ChargeTimer_timeout():
	$BlinkTimer.stop()
	$Sprite.modulate = default_color
	direction = player.position - position
	dashing = true

# Times when the boss crashed into the side and when it should start the next attack sequence.
func _on_AttackCooldownTimer_timeout():
	$ChargeTimer.start()
	$BlinkTimer.start()

func _on_DashBoss_area_entered( area ):
	if !spawning and !died:
		if area.is_in_group("bullets"):
			health -= 1
			area.hit(self)
		if area.get_name() == "Player":
			# After killed, the boss will now charge through the center.
			# Need to come up with something better eventually.
			area.position = Vector2(512, 288)
			area.hit(self)
