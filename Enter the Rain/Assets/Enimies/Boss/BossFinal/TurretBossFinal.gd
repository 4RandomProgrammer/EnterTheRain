extends KinematicBody2D

export var speed = 100
onready var Timer_shot = $Timer_shoot
onready var Bullet = load("res://Assets/Enimies/Enemy_bullet/SlowBigBullet.tscn")
onready var Explosion = load("res://Assets/Enimies/Explosion.tscn")
var bullet_reload_time = 0.4
enum {
	SPAWNING,
	NORMAL,
	POWER_1
}
var state = SPAWNING
var velocity = Vector2.ZERO

func _physics_process(delta):
	match state:
		NORMAL:
			movimentation(delta)
			shoot()
		POWER_1:
			power_1()


func shoot():
	if Timer_shot.time_left == 0:
		var bullet = Bullet.instance()
		bullet.start(global_position, rotation + rand_range(-PI / 12, PI / 12))
		get_parent().get_parent().call_deferred('add_child', bullet)
		Timer_shot.start(bullet_reload_time)


func movimentation(delta):
	var colision = move_and_collide(velocity * delta * speed)  # Mover para um lado.
	if colision:  # Se colidir com a parede invisivel, começar a voltar.
		velocity = -velocity


func power_1():
	pass


func _on_Timer_pow1_timeout():
	pass


func _on_HurtBox_area_entered(area):
	if state != SPAWNING:
		var damage_taken = area.DAMAGE
		$Stats.Health -= damage_taken

func _on_Stats_no_health():  # Explodir e morrer...
	var explosion = Explosion.instance()
	explosion.position = global_position
	get_parent().get_parent().call_deferred('add_child', explosion)
	queue_free()


func _on_Timer_change_dir_timeout():  # Mudar de direcao em tempos aleatorios
	velocity = -velocity
	$Timer_change_dir.start(rand_range(3, 15))
