extends Node2D

onready var Player = get_parent().get_node('Player')
onready var Bullet_tscn = load("res://Assets/Enimies/Enemy_bullet/SlowBigBullet.tscn")
var speed = 100
var Bullets_list
var velocity = Vector2.ZERO

func start(pos, dir):
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)


func _ready():
	randomize()
	Bullets_list = [$EnemyBullet, $EnemyBullet2, $EnemyBullet3, $EnemyBullet4, $EnemyBullet5, $EnemyBullet6, $EnemyBullet7,
					$EnemyBullet8, $EnemyBullet9, $EnemyBullet10, $EnemyBullet11, $EnemyBullet12, $EnemyBullet13, $EnemyBullet14,
					$EnemyBullet15, $EnemyBullet16]
	Bullets_list.shuffle()
	$Timer_stop.start(rand_range(5, 10))


func _physics_process(delta):
	position += velocity * delta
	rotation += delta * 2


func _on_Timer_stop_timeout():
	velocity = Vector2.ZERO
	$Timer_shoot.start()


func _on_Timer_shoot_timeout():  # Começar a soltar as bullets
	if len(Bullets_list) == 0:  # Quando não existir mais bullets para soltar, sumir com esse objeto
		queue_free()
		return
	
	var Bullet = Bullets_list[0]
	Bullets_list.pop_front()
	if is_instance_valid(Bullet) and is_instance_valid(Player):  # Se a bullet atual selecionada nao foi destruida ainda...
		# Criar uma bullet no lugar dela que vai até o player e sumir com ela mesma (dando impressão que foi ela que foi até o player...)
		var bullet = Bullet_tscn.instance()
		bullet.start(Bullet.global_position, (Player.global_position - Bullet.global_position).angle())
		get_parent().call_deferred('add_child', bullet)
		Bullet.queue_free()
	else:
		$Timer_shoot.start(0)
