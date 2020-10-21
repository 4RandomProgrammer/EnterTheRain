extends "res://Assets/Enimies/Perseguidores/Enemy_chaser_base.gd"

export var shot_cooldown = 0.2
var spin = 0
var can_shoot = false
var Bullet = load("res://Assets/Enimies/Enemy_bullet/EnemyBullet.tscn")


func chase():
	if can_shoot:
		shoot(enemy_range.target.position)
	elif $ShootTimer.is_stopped():  # O timer acabou, recomeçar a contagem para o proximo tiro.
		$ShootTimer.start(shot_cooldown)
	direction = global_position.direction_to(enemy_range.target.global_position)
	velocity = velocity.move_toward(direction * velocidade, velocidade / 2)

func shoot(pos):
	var bullet = Bullet.instance()
	bullet.start(global_position, rad2deg(spin))
	get_parent().add_child(bullet)
	can_shoot = false
	spin = spin + PI/360
	if spin == 2 * PI:
		spin = 0

func player_exited_range():
	# Player saiu do range. Parar o timer do tiro, para que o inimigo nao atire instantaneamente quando o player voltar.
	$ShootTimer.stop()
	can_shoot = false


func _on_ShootTimer_timeout():
	can_shoot = true
