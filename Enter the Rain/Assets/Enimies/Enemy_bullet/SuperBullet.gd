extends "res://Assets/Enimies/Enemy_bullet/EnemyBullet.gd"

export (Resource)var bullet

func _on_Timer_timeout():
	create_other_bullets()
	on_explode()
	queue_free()


func create_other_bullets():
	var direction = 0
	while direction < 2 * PI:
		var bullet_spawn = bullet.instance()
		bullet_spawn.start(global_position, direction)
		get_parent().call_deferred('add_child', bullet_spawn)
		direction += PI / 5

func on_collision():
	can_disapear = false
	velocity = -velocity
	$Timer_fix.start()  # Ao bater em uma parede, andar 0,02s na direção oposta para não explodir na parede e perder as bullets.
	create_other_bullets()


func _on_Timer_fix_timeout():
	on_explode()
	create_other_bullets()
	queue_free()

func on_explode():
	pass
