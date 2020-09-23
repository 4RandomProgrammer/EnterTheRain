extends KinematicBody2D

onready var velocity = 100
onready var extra_speed = 1
onready var directions = [Vector2(velocity, velocity), Vector2(- velocity, - velocity),
						Vector2(- velocity, velocity), Vector2(velocity, - velocity)]
onready var timer_stop = $Timer_parar
onready var timer_walk = $Timer_andar
onready var timer_pow_2 = $Power_2_timer
onready var timer_pow_3 = $Power_3_timer
onready var Enemy_bullet = load("res://Assets/Enimies/Enemy_bullet/EnemyBullet.tscn")
onready var Super_bullet = load("res://Assets/Enimies/Enemy_bullet/SuperBullet.tscn")
onready var Big_bullet = load("res://Assets/Enimies/Enemy_bullet/SlowBigBullet.tscn")
onready var stats = $Stats
onready var boss_range = $Alcance
onready var rng = RandomNumberGenerator.new()
export var quant_bullets_pow2 = 50
export var rotation_speed_pow1 = 100
var final_ang = 2 * PI
var current_dir
var angle_pat_1 = 0
var bullet_reload = 0.4
export var damage = 1
enum {
	WALKING
	POWER_1
	POWER_2
	POWER_3
	SPAWNING
}
var state = SPAWNING
var target
var can_shoot = true

signal healthChanged(health)
signal Spawning(maxHealth)
signal Died


func _ready():
	rng.randomize()
	velocity = directions[rng.randi_range(0, 3)]
	var bossHealthBar = get_parent().get_node('Player').get_node('Camera2D').get_node('CanvasLayer').get_node('HealthBarBoss')
	connect("Spawning", bossHealthBar, "_on_Boss_Spawning")
	connect("Died", bossHealthBar, "_on_Boss_Died")
	connect("healthChanged", bossHealthBar, "_on_Boss_healthChanged")
	emit_signal("Spawning", $Stats.MaxHealth)


func _physics_process(delta):
	match state:
		WALKING:
			try_aim_player()
			var collision = move_and_collide(velocity * delta * extra_speed)
			if collision:
				velocity = velocity.bounce(collision.normal)  # Toda vez que bater em algo, rebater.
		POWER_1:
			try_aim_player()
			power_1()
		POWER_2:
			try_aim_player()
			if timer_pow_2.time_left == 0:
				power_2()
				timer_pow_2.start()
		POWER_3:
			try_aim_player()
			if timer_pow_3.time_left == 0:
				power_3()
				timer_pow_3.start()
		SPAWNING:
			$Sprite.self_modulate.r = 0.2


func shoot(pos):  # Atirar no player.
	var bullet = Big_bullet.instance()
	var dir = (pos - global_position).angle() 
	bullet.start(global_position, dir + rand_range(-0.1, 0.1))
	get_parent().add_child(bullet)
	can_shoot = false
	$Bullet_timer.start(bullet_reload)


func power_1():
	current_dir = 0
	angle_pat_1 += rotation_speed_pow1 * 0.0001
	rotation += rotation_speed_pow1 * 0.0001
	while current_dir < final_ang:  # Adicionar 90° (pi/2) a cada loop. Isso criará bullets nas 4 direções.
		var bullet_pat_1 = Enemy_bullet.instance()
		bullet_pat_1.start(global_position, current_dir + angle_pat_1)
		get_parent().add_child(bullet_pat_1)
		current_dir += PI / 2


func power_2():
	current_dir = 0
	var denominator = (quant_bullets_pow2 / 2.0)
	while current_dir < final_ang:
		var bullet_pat_2 = Big_bullet.instance()
		bullet_pat_2.start(global_position, current_dir)
		get_parent().add_child(bullet_pat_2)
		current_dir += PI / denominator


func power_3():
	current_dir = rand_range(0, final_ang)
	var bullet_pat_3 = Super_bullet.instance()
	bullet_pat_3.start(global_position, current_dir)
	get_parent().add_child(bullet_pat_3)


func try_aim_player():  # Tentar atirar no player se tiver no range e sem obstaculos na frente.
	if boss_range.entity_aimed():
		if can_shoot:
			shoot(boss_range.target.position)


func _on_Timer_parar_timeout():  # Começar a andar novamente por 10s.
	velocity = directions[rng.randi_range(0, 3)]
	$Sprite.self_modulate.r = 1
	timer_walk.start(10)
	state = WALKING


func _on_Timer_andar_timeout():  # Parar por 5s.
	timer_stop.start(5)
	var power = rng.randi_range(1, 3)
	if power == 1:
		state = POWER_1
	elif power == 2:
		state = POWER_2
	else:
		state = POWER_3


func _on_Stats_no_health():
	emit_signal('Died')
	queue_free()


func _on_HurtBox_area_entered(area):
	if state != SPAWNING:
		extra_speed += 0.05 * area.DAMAGE
		bullet_reload -= 0.01
		var damage_taken = area.DAMAGE
		stats.Health -= damage_taken
		emit_signal('healthChanged', stats.Health)


func _on_Bullet_timer_timeout():
	can_shoot = true


func _on_StunTimer_timeout():
	state = WALKING
