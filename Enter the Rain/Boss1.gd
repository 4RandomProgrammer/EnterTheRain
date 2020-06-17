extends KinematicBody2D

onready var velocidade = 100
onready var direcoes = [Vector2(velocidade, velocidade), Vector2(- velocidade, - velocidade),
						Vector2(- velocidade, velocidade), Vector2(velocidade, - velocidade)]
onready var timer_parar = $Timer_parar
onready var timer_andar = $Timer_andar
onready var enemy_bullet = load("res://Assets/Enemy_bullet/EnemyBullet.tscn")
onready var stats = $Stats
var movimento = Vector2.ZERO
enum {
	PARADO
	ANDANDO
}
var estado = ANDANDO
var target
var can_shoot = true


func _ready():
	velocidade = direcoes[0]


func _physics_process(delta):
	if target:
		aim()
	match estado:
		ANDANDO:
			var colisao = move_and_collide(velocidade * delta)
			if colisao:
				print('BATEU')
				velocidade = velocidade.bounce(colisao.normal)
		PARADO:
			pass


func aim():
	var space_state = get_world_2d().direct_space_state
	var target_extents = target.get_node('CollisionShape2D').shape.extents - Vector2(5, 5)
	var nw = target.position - target_extents
	var se = target.position + target_extents  
	var ne = target.position + Vector2(target_extents.x, -target_extents.y)  
	var sw = target.position + Vector2(-target_extents.x, target_extents.y)  
	for pos in [target.position, nw, ne, se, sw]:  
		var result = space_state.intersect_ray(position,
				pos, [self], collision_mask)
		if result:
			if result.collider.name == "Player":  
				rotation = (target.position - position).angle()
				if can_shoot:
					shoot(pos)
				break


func shoot(pos):
	var bullet = enemy_bullet.instance()
	var dir = (pos - global_position).angle() 
	bullet.start(global_position, dir + rand_range(-0.05, 0.05))
	get_parent().add_child(bullet)
	can_shoot = false
	$Bullet_timer.start()


func _on_Timer_parar_timeout():
	print('Hora de parar')
	timer_andar.start(5)
	estado = PARADO


func _on_Timer_andar_timeout():
	print('Hora de andar')
	timer_andar.start(10)
	estado = ANDANDO

func _on_Alcance_body_entered(body):
	if target:
		return
	target = body


func _on_Alcance_body_exited(body):
	if body == target:
		target = null


func _on_Stats_no_health():
	queue_free()


func _on_HurtBox_area_entered(area):
	var dano = area.DAMAGE
	stats.Health -= dano


func _on_Bullet_timer_timeout():
	can_shoot = true
