extends Node

var score = 0
var boss1_spawned = false

onready var score_label = $GUI/CenterText

onready var default_color = $GUI/BossMessage.modulate
var danger_color = Color(1.0, .082, .075)
var danger_on = false

func _ready():
	randomize()
	
func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
	
	if not boss1_spawned and score == 25:
		$SpawnManager.stop()
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.fleeing = true
		start_boss_spawn()
		
func start_boss_spawn():
	boss1_spawned = true
	$GUI/CenterText.hide()
	$GUI/BossMessage.show()
	$BossMessageTimer.start()
	$BlinkTimer.start()

func get_player():
	return $Player
	
func normal_mode():
	$GUI/CenterText.show()
	$BossHealthBar.hide()
		
func on_enemy_die(enemy):
	score += enemy.points
	score_label.text = str(score)
	if enemy.is_in_group("bosses"):
		$SpawnManager.start()
		$SpawnManager/BossSpawner.stop()
		normal_mode()

func _on_BasicSpawner_enemy_created( enemy ):
	enemy.connect("enemy_died", self, "on_enemy_die")

func _on_Player_died():
	$GUI/DeathGUI.show()
	normal_mode()

func _on_PlayAgain_pressed():
	get_tree().reload_current_scene()
	
func clear_enemies():
	for child in get_children():
			if child.is_in_group("enemies"):
				child.queue_free()

func _on_BossMessageTimer_timeout():
	clear_enemies()
	$BlinkTimer.stop()
	$SpawnManager.spawn_boss()
	$GUI/BossMessage.hide()
	$BossHealthBar.init()
	$BossHealthBar.show()
	
func _on_BlinkTimer_timeout():
	if danger_on:
		$GUI/BossMessage.modulate = danger_color
		danger_on = false
	else:
		$GUI/BossMessage.modulate = default_color
		danger_on = true
