extends KinematicBody2D

onready var random_moviment = $Movimento_aletorio
onready var missile = load('res://Assets/Enimies/Enemy_missile.tscn')
onready var explosive_bullet = load("res://Assets/Enimies/Enemy_bullet/Explosive_bullet.tscn")
onready var enemy_bullet = load("res://Assets/Enimies/Enemy_bullet/EnemyBullet.tscn")
onready var boss_range = $Range
var rng = RandomNumberGenerator.new()
var direction
var speed = 100
onready var stats = $Stats
onready var shoot_timer  = $Shoot_timer
var velocity = Vector2.ZERO
var damage = 1
var can_shoot = false
enum {
	SPAWNING,
	WALKING
}
var state = WALKING

func _physics_process(delta):
	match state:
		SPAWNING:
			$Sprite.self_modulate.r = 0.2
		WALKING:
			movimentation(delta)
			aim_player()


func movimentation(delta):
	direction = global_position.direction_to(random_moviment.target_position)  # Pegar posic. aleatória do modulo 'movimento_aleatorio'
	velocity = velocity.move_toward(direction * speed * delta, speed * delta)
	var collision = move_and_collide(velocity)
	if global_position.distance_to(random_moviment.target_position) <= 10:
		random_moviment.update_target_position()
	if collision:
		random_moviment.update_target_position()


func _on_Missile_timer_timeout():
	var Missile = missile.instance()
	if boss_range.entity_aimed():
		Missile.start(global_position, (boss_range.target.position - global_position).angle() + rand_range(-0.5, 0.5))
	else:
		Missile.start(global_position, rng.randi_range(0, 360))
	get_parent().add_child(Missile)
	$Missile_timer.start(rng.randf_range(0, 5))


func _on_HurtBox_area_entered(area):
	if state != SPAWNING:
		var damage_taken = area.DAMAGE
		stats.Health -= damage_taken

func aim_player():
	if boss_range.entity_aimed():
		if can_shoot:
			shoot(boss_range.target.position)
	else:
		can_shoot = false
		shoot_timer.start()

func shoot(pos):  # Atirar no player.
	# Criando a bullet explosiva
	var Explosive_bullet = explosive_bullet.instance()
	var dir = (pos - global_position).angle()
	Explosive_bullet.start(global_position, dir + rand_range(-0.05, 0.05))
	get_parent().add_child(Explosive_bullet)
	# Criando as duas bullets comuns
	for angle in [dir + PI/8, dir - PI/8]:
		var Enemy_bullet = enemy_bullet.instance()
		Enemy_bullet.start(global_position, angle)
		get_parent().add_child(Enemy_bullet)
	can_shoot = false
	shoot_timer.start()


func _on_Stats_no_health():
	queue_free()


func _on_Shoot_timer_timeout():
	can_shoot = true
