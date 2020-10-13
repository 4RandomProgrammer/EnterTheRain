extends "res://Assets/Enimies/Perseguidores/Enemy_chaser_base.gd"

export var shoot_cd = 0.25

var can_shoot = false
var Bullet = load("res://Assets/Enimies/Enemy_bullet/EnemyBullet.tscn")


func chase():
	if can_shoot:
		shoot(enemy_range.target.position)
	elif $ShootTimer.is_stopped():  # O timer acabou, recomeçar a contagem para o proximo tiro.
		$ShootTimer.start(shoot_cd)
	direction = global_position.direction_to(enemy_range.target.global_position)
	velocity = velocity.move_toward(direction * velocidade, velocidade / 2)

func shoot(pos):
	var bullet = Bullet.instance()
	var angle = (pos - global_position).angle()
	bullet.start(global_position, angle + rand_range(-0.75, 0.75))
	get_parent().add_child(bullet)
	can_shoot = false

func player_exited_range():
	# Player saiu do range. Parar o timer do tiro, para que o inimigo nao atire instantaneamente quando o player voltar.
	$ShootTimer.stop()
	can_shoot = false

func _on_ShootTimer_timeout():
	can_shoot = true


func _on_Rush_Area_body_entered(body):
	if enemy_range.entity_aimed():
		velocidade = 200


func _on_Rush_Area_body_exited(body):
	velocidade = 100
