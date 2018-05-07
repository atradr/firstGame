extends Node

export (PackedScene) var Enemy
export (float) var spawn_time = 2
export (bool) var one_shot = false
export (bool) var auto_start = true

signal enemy_created(enemy)

func _ready():
	$SpawnTimer.set_wait_time(spawn_time)
	$SpawnTimer.set_one_shot(one_shot)
	if auto_start:
		$SpawnTimer.start()

func _on_SpawnTimer_timeout():
	var enemy = Enemy.instance()
	$"/root/Main".add_child(enemy)
	enemy.init()
	emit_signal("enemy_created", enemy)
	
func start():
	$SpawnTimer.start()

func stop():
	$SpawnTimer.stop()