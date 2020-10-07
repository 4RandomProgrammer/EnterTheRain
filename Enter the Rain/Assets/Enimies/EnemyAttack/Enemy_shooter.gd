extends "res://Assets/Enimies/Perseguidores/Enemy_chaser_base.gd"

const Bullet = preload("res://Assets/Enimies/Enemy_bullet/EnemyBullet.tscn")

var can_shoot = true

func chase():
	direction = global_position.direction_to(enemy_range.target.global_position)
	velocity = velocity.move_toward(direction * velocidade, velocidade / 2)

func shoot(pos):  # Função que atira na direção do player.
	var bullet = Bullet.instance()
	var angle = (pos - global_position).angle()
	bullet.start(global_position, angle + rand_range(-0.05, 0.05))
	get_parent().call_deferred('add_child', bullet)
	can_shoot = false  # Após um tiro, deve-se dar um delay para o próximo tiro.
	$ShootTimer.start()


func _on_Range_shoot_body_entered(body):
	if enemy_range.entity_aimed():
		rotation = (enemy_range.target.position - position).angle()
		if can_shoot:
			shoot(enemy_range.target.position)
	else:
		can_shoot = false
		$ShootTimer.start()


func _on_ShootTimer_timeout():
	can_shoot = true
