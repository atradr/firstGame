extends Area2D

export (PackedScene) var Bullet
export var SPEED = 500

onready var pivot = $"../Pivot"
onready var joystick = $"../Joystick"

signal died

var velocity = Vector2(0,0)
var direction = Vector2(0,0)
var screensize

var dash_speed = 1450
var dash_time = .20
var dashing = false

var dead = false

var joyStart = Vector2(0,0)
var joyCurrent = Vector2(0,0)
var joyPressed = false

var OS_name

func _ready():
	screensize = get_viewport_rect().size
	$DashTimer.wait_time = dash_time
	set_process_input(true)
	OS_name = OS.get_name()

func _process(delta):
	joyCurrent = get_global_mouse_position()
	joystick.set_location(joyCurrent)
	if !dead:
		#if !dashing:
		direction = Vector2(0,0)
		if OS_name == "Windows" or OS_name == "HTML5" or OS_name == "OSX":
			if Input.is_action_pressed("ui_right"):
				direction.x += 1
			if Input.is_action_pressed("ui_left"):
				direction.x -= 1
			if Input.is_action_pressed("ui_down"):
				direction.y += 1
			if Input.is_action_pressed("ui_up"):
				direction.y -= 1
		if OS_name == "Android" or OS_name == "iOS":
			if Input.is_mouse_button_pressed(BUTTON_LEFT):
				direction = joystick_direction() / 100
		
		if !dashing:
			velocity = direction * SPEED
			if velocity.length() > SPEED:
				velocity = velocity.normalized() * SPEED
				
		# May need to add a small cool down timer, or disable the ability to hold Space.
		if !dashing and Input.is_key_pressed(KEY_SPACE):
			dash()
			
		position += velocity * delta
		position.x = clamp(position.x, 0, screensize.x)
		position.y = clamp(position.y, 0, screensize.y)
		rotation = atan2(pivot.position.x - position.x, position.y - pivot.position.y)

func _input(ev):
	if ev is InputEventScreenTouch and ev.is_pressed():
		if ev.index > 0:
			dash()
	elif ev is InputEventMouseButton:
		if ev.is_pressed():
			if !joyPressed:
				joyStart = ev.get_position()
				joystick.activate(ev.get_position())
				joyPressed = true
		else:
			joyStart = Vector2(0,0)
			joyCurrent = Vector2(0,0)
			joystick.deactivate()
			joyPressed = false
			
func joystick_direction():
	return joyCurrent - joyStart
	
func dash():
	dashing = true
	velocity = direction.normalized() * dash_speed
	$DashTimer.start()
	$Sounds/DashSound.play()
	
func hit(enemy):
	if (enemy.is_in_group("hazard")):
		dead = true
		hide()
		emit_signal("died")

func _on_ShotTimer_timeout():
	if !dead and !dashing:
		var bullet = Bullet.instance()
		$"..".add_child(bullet)
		bullet.init(position)

func _on_DashTimer_timeout():
	dashing = false

# This terrible function is a result of my terrible code
func _on_Player_area_entered( area ):
	if area.is_in_group("outside_area"):
		var boss = area.get_parent().get_parent()
		if !boss.spawning and !boss.died:
			hit(area)
