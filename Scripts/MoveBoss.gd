extends "Boss.gd"

var direction
var hover_speed = 20
var hover_duration
var hover_dur_min = .5
var hover_dur_max = 1
var anchor_position

var move_speed = 300
var target_pos
var moving = false

var time_since_hover_start = 0

func _ready():
	position = Vector2(250, rand_range(200, 376))
	hover_duration = rand_range(hover_dur_min, hover_dur_max)
	direction = Vector2(.1,.1)
	anchor_position = position
	default_color = modulate
	show()
	
# Need the speed to decrease over a movement
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
	
	rotation += delta * (-health_ratio + 2) * 1.5
	$CooldownTimer.wait_time = health_ratio / 2
	
	time_since_hover_start += delta
	if time_since_hover_start > hover_duration:
		# Change direction to move back towards the anchor
		var x_dir = sign(anchor_position.x - position.x) * randf()
		var y_dir = sign(anchor_position.y - position.y) * randf()
		direction = Vector2(x_dir, y_dir)
		hover_duration = rand_range(hover_dur_min, hover_dur_max)
		time_since_hover_start = 0
		direction = direction.normalized()
		
	var movement_vec = direction * hover_speed
	if moving:
		var angle = target_pos - position
		angle = angle.normalized()
		movement_vec += move_speed * angle
		anchor_position = position
		if abs(position.x - target_pos.x) < 5:
			moving = false
	position += movement_vec * delta

func _on_AnimationPlayer_animation_finished( anim_name ):
	if anim_name == "AttackAnim":
		$CooldownTimer.start()
	if anim_name == "SpawnAnim":
		$CooldownTimer.start()
		spawning = false

func _on_CooldownTimer_timeout():
	$AttackTimer.start()
	$BlinkTimer.start()

func _on_AttackTimer_timeout():
	$BlinkTimer.stop()
	modulate = default_color
	if !died:
		$AnimationPlayer.play("AttackAnim")
		moving = true
		var t_x
		if position.x > 512:
			t_x = 250
		else:
			t_x = 774
		target_pos = Vector2(t_x, rand_range(200, 376))

func _on_BlinkTimer_timeout():
	if danger_on:
		modulate = danger_color
		danger_on = false
	else:
		modulate = default_color
		danger_on = true

func _on_MoveBoss_area_entered( area ):
	if !spawning and !died:
		if area.is_in_group("bullets"):
			health -= 1
			area.hit(self)
		if area.get_name() == "Player":
			area.hit(self)

func take_damage():
	if !spawning:
		health -=1