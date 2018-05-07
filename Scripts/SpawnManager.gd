extends Node

func start():
	for spawner in get_children():
		if not spawner.is_in_group("boss_spawners"):
			spawner.start()
		
func stop():
	for spawner in get_children():
		spawner.stop()
		
func spawn_boss():
	for spawner in get_children():
		if spawner.is_in_group("boss_spawners"):
			spawner.start()