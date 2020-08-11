extends "res://Assets/Spawners/RandomSpawner.gd"
var target_spawn_explosive = load("res://Assets/Enimies/Boss/Target_spawn_explosive.tscn")
var explosion_target = load("res://Assets/Enimies/Explosion_target.tscn")
var boss_2

func _on_Timer_timeout():
	if rng.randi_range(1, 100) <= 90:
		var Explosion_target = create_entity_in_range(explosion_target)
		if Explosion_target:
			get_parent().call_deferred('add_child', Explosion_target)
	else:
		var Target_spawn_explosive = create_entity_in_range(target_spawn_explosive)
		if Target_spawn_explosive:
			get_parent().call_deferred('add_child', Target_spawn_explosive)


func _on_Timer_end_timeout():
	get_parent().add_child(boss_2)  # Respawnar o boss
	queue_free()
