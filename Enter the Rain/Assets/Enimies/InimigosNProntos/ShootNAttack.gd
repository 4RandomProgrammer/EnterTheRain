extends "res://Assets/Enimies/InimigosNProntos/Enemy_attack_base.gd"

var can_shoot = false

const BULLET = preload("res://Assets/Enimies/Enemy_bullet/EnemyBullet.tscn")

func chase():
	$Sprite.frame = 1
	
	if can_shoot:
		shoot(enemy_range.target.position)
	elif $ShootTimer.is_stopped():  # O timer acabou, recomeçar a contagem para o proximo tiro.
		$ShootTimer.start()
	
	direction = global_position.direction_to(enemy_range.target.global_position)
	velocity = velocity.move_toward(direction * velocidade, velocidade / 2)

func shoot(pos):
	var bullet = BULLET.instance()
	var angle = (pos - global_position).angle()
	bullet.start(global_position, angle + rand_range(-0.05, 0.05))
	get_parent().add_child(bullet)
	can_shoot = false


func _on_ShootTimer_timeout():
	can_shoot = true
