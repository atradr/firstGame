extends Node

export (PackedScene) var shootBoss
export (PackedScene) var moveBoss

var save_data
var highscore = 0
var bosses_defeated_hs = 0

var score = 0
var boss1_kills = 0
var boss2_kills = 0
var boss3_kills = 0
var spawn_increased = false
var boss1_spawned = false
var boss2_spawned = false
var boss3_spawned = false

onready var score_label = $GUI/CenterText

onready var default_color = $GUI/BossMessage.modulate
var danger_color = Color(1.0, .082, .075)
var danger_on = false

func _ready():
	randomize()
	load_game()
	highscore = save_data["highscore"]
	boss1_kills = save_data["boss1_kills"]
	boss2_kills = save_data["boss2_kills"]
	boss3_kills = save_data["boss3_kills"]
	var OS_name = OS.get_name()
	if OS_name == "Android" or OS_name == "iOS":
		$GUI/PauseButton.show()
	
func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
	
	if not spawn_increased and score >= 10:
		$SpawnManager/BasicSpawner2.spawn_time = 2
		$SpawnManager/BasicSpawner.spawn_time = 1
		spawn_increased = true
		
	if not boss1_spawned and score >= 25:
		$SpawnManager.stop()
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.fleeing = true
		boss1_spawned = true
		boss_mode()
	
	if not boss2_spawned and score >= 60:
		$SpawnManager.stop()
		$SpawnManager/BossSpawner.set_enemy(shootBoss)
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.fleeing = true
		boss2_spawned = true
		boss_mode()
	
	if not boss3_spawned and score >= 95:
		$SpawnManager.stop()
		$SpawnManager/BossSpawner.set_enemy(moveBoss)
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.fleeing = true
		boss3_spawned = true
		boss_mode()

func normal_mode():
	$GUI/CenterText.show()
	$BossHealthBar.hide()

func boss_mode():
	$GUI/CenterText.hide()
	$GUI/BossMessage.show()
	$BossMessageTimer.start()
	$BlinkTimer.start()
	
func on_enemy_die(enemy):
	score += enemy.points
	score_label.text = str(score)
	if enemy.is_in_group("bosses"):
		$SpawnManager.start()
		$SpawnManager/BossSpawner.stop()
		normal_mode()
		if enemy.is_in_group("dash_boss"):
			boss1_kills += 1
		elif enemy.is_in_group("shoot_boss"):
			boss2_kills += 1
		elif enemy.is_in_group("move_boss"):
			boss3_kills += 1

func _on_BasicSpawner_enemy_created( enemy ):
	enemy.connect("enemy_died", self, "on_enemy_die")

func _on_Player_died():
	$GUI/DeathGUI.show()
	$GUI/PauseButton.hide()
	$SpawnManager.stop()
	normal_mode()
	save_game()

func _on_PlayAgain_pressed():
	get_tree().reload_current_scene()
	
func clear_enemies():
	for child in get_children():
			if child.is_in_group("enemies"):
				child.queue_free()

func get_highscore():
	if highscore > score:
		return highscore
	else:
		return score

func save_game():
	var save_game = File.new()
	save_game.open("user://game.save", File.WRITE)
	save_game.store_line(to_json(get_save_data()))
	save_game.close()

func get_save_data():
	var save_data = {
		"highscore" : get_highscore(),
		"boss1_kills" : boss1_kills,
		"boss2_kills" : boss2_kills,
		"boss3_kills" : boss3_kills
	}
	return save_data

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://game.save"):
		save_data = get_default_save_state()
		return
	save_game.open("user://game.save", File.READ)
	save_data = parse_json(save_game.get_line())
	save_game.close()

func get_default_save_state():
	var data = {
		"highscore" : 0,
		"boss1_kills" : 0,
		"boss2_kills" : 0,
		"boss3_kills" : 0
	}
	return data

func _on_BossMessageTimer_timeout():
	clear_enemies()
	$BlinkTimer.stop()
	$SpawnManager.spawn_boss()
	$GUI/BossMessage.hide()
	$BossHealthBar.init()
	$BossHealthBar.show()
	
func _on_BlinkTimer_timeout():
	if danger_on:
		$GUI/BossMessage.add_color_override("font_color", danger_color)
		danger_on = false
	else:
		$GUI/BossMessage.add_color_override("font_color", default_color)
		danger_on = true

func _on_ToMenu_pressed():
	get_tree().change_scene("MainScenes/MainMenu.tscn")

func _on_PauseButton_pressed():
	get_tree().paused = true


func _on_PauseButton_toggled( button_pressed ):
	if button_pressed:
		get_tree().paused = true
	else:
		get_tree().paused = false
