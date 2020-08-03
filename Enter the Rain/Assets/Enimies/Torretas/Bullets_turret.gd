extends "res://Assets/Enimies/Torretas/Turret_base.gd"
var Bullet = load("res://Assets/Enimies/Enemy_bullet/EnemyBullet.tscn")


func try_aim_player_and_shoot():  # Função que tentará atirar no player. Só atirará quando tiver no range e sem obstaculos na frente.
	if turret_range.entity_aimed():
		rotation = (turret_range.target.position - position).angle()
		if can_shoot:
			shoot(turret_range.target.position)
	else:  # Resetar o timer se o player não estiver na mira (faz com que a torre não atire imediatamente)
		can_shoot = false
		$ShootTimer.start()

func shoot(pos):  # Função que atira na direção do player.
	var bullet = Bullet.instance()
	var angle = (pos - global_position).angle()
	bullet.start(global_position, angle + rand_range(-0.05, 0.05))
	get_parent().add_child(bullet)
	can_shoot = false  # Após um tiro, deve-se dar um delay para o próximo tiro.
	$ShootTimer.start()
