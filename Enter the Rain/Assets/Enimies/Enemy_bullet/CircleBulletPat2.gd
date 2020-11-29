extends Node2D

export var quant_bullets = 10
export var time_reload = 0.5
onready var Bullet_tscn = load("res://Assets/Enimies/Enemy_bullet/SlowBigBullet.tscn")
var speed = 100
var Bullets_list = []
var velocity = Vector2.ZERO


func start(pos, dir):
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)

func _ready():
	randomize()
	for i in range(1, quant_bullets + 1):  # Criar bullets na borda de um circulo, spawna-los e adicionar em uma lista
		var bullet = Bullet_tscn.instance()
		bullet.position = Vector2(5 * quant_bullets, 0).rotated(i * 2 * PI / quant_bullets)
		add_child(bullet)
		Bullets_list.append(bullet)
		bullet.timer_duration.stop()
	Bullets_list.shuffle()
	$Timer_stop.start(rand_range(5, 10))

func _physics_process(delta):
	position += velocity * delta
	rotation += delta * 2


func _on_Timer_stop_timeout():  # Parar de mover as bullets em linha reta. Começar a sollta-las
	velocity = Vector2.ZERO
	$Timer_shoot.start(time_reload)


func _on_Timer_shoot_timeout():
	if len(Bullets_list) == 0:  # Quando não existir mais bullets para soltar, sumir com esse objeto
		queue_free()
		return
	
	var Bullet = Bullets_list[0]
	Bullets_list.pop_front()
	if is_instance_valid(Bullet) and $Range.entity_aimed():  # Se a bullet atual selecionada nao foi destruida ainda...
		# Criar uma bullet no lugar dela que vai até o player e sumir com ela mesma (dando impressão que foi ela que foi até o player...)
		var bullet = Bullet_tscn.instance()
		bullet.start(Bullet.global_position, ($Range.target.position - Bullet.global_position).angle() + rand_range(-PI/8, PI/8))
		get_parent().call_deferred('add_child', bullet)
		Bullet.queue_free()
		$Timer_shoot.start(time_reload)
	else:
		$Timer_shoot.start(0)
