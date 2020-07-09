extends "res://Assets/Enemy_bullet/EnemyBullet.gd"
onready var bullet = load("res://Assets/Enemy_bullet/EnemyBullet.tscn")

func _ready():
	$Timer.start(rand_range(0.5, 1.5))

func _on_Timer_timeout():
	var direction = 0
	while direction < 2 * PI:
		var bullet_spawn = bullet.instance()
		bullet_spawn.start(global_position, direction)
		get_parent().add_child(bullet_spawn)
		direction += PI / 5
	queue_free()
