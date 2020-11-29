extends KinematicBody2D

onready var stats = $Stats_melee
onready var timer_sword_hit = $Timer_hit
onready var timer_power1 = $Timer_power_1
onready var timer_shot_p1 = $Timer_shot_p1
onready var boss_range = get_parent().get_node('Range')

onready var Bullet = load("res://Assets/Enimies/Enemy_bullet/SlowBigBullet.tscn")
enum {
	SPAWNING,
	SWORD_HIT,
	NORMAL,
	DELAY_POWER_1,
	DASHING_POWER_1,
	KNOCKED
}
var initial_x_pos
var hit_delay_time = 0.5
var sword_hit_duration = 0.3
var atacking = false
var damage = 1
var state = SPAWNING
var speed = 250
var velocity = Vector2.ZERO
var player_last_pos
var delay_min_p1 = 8
var delay_max_p1 = 14

signal Spawning
signal healthChanged
signal Died


func _ready():
	initial_x_pos = position.x - 75
	# Conectando os sinais:
	var bossHealthBar1 = get_parent().get_parent().get_parent().get_node('Player').get_node('Camera2D').get_node('CanvasLayer').get_node('HealthBarBoss')
	connect("Spawning", bossHealthBar1, "_on_Boss_Spawning")
	connect("healthChanged", bossHealthBar1, "_on_Boss_healthChanged")
	emit_signal("Spawning", stats.MaxHealth, 'Furioso')

func _physics_process(delta):
	if boss_range.entity_aimed():
		match state:
			NORMAL:
				movimentation(speed, delta, boss_range.target.position)
				if global_position.distance_to(boss_range.target.position) <= 60:  # Player está proximo do boss (hitar com espada)
					timer_sword_hit.start(hit_delay_time)
					state = SWORD_HIT
			DELAY_POWER_1:
				player_last_pos = boss_range.target.position
			DASHING_POWER_1:
				movimentation(speed * 2, delta, player_last_pos)
				shoot_power1()
				if global_position.distance_to(player_last_pos) <= 60:
					state = NORMAL
					timer_power1.start(rand_range(delay_min_p1, delay_max_p1))

func movimentation(speed, delta, player_pos): # Movimentação do boss
	var direction = global_position.direction_to(player_pos)
	velocity = velocity.move_toward(direction * speed * delta, speed / 2)
	rotation = direction.angle()
	move_and_collide(velocity)


func _on_HurtBox_area_entered(area):  # Inimigo recebeu dano...
	if state != SPAWNING and state != KNOCKED:
		var damage_taken = area.DAMAGE
		stats.Health -= damage_taken
		emit_signal('healthChanged', stats.Health)


func _on_Timer_spawn_timeout():
	state = NORMAL
	timer_power1.start(rand_range(delay_min_p1, delay_max_p1))

func _on_Stats_melee_no_health(): # Inimigo foi "nocauteado".
	state = KNOCKED
	$Sprite.self_modulate.r = 0.2

func revive():  # Revivendo o boss. Player demorou muito para matar o outro boss(range).
	$Sprite.self_modulate.r = 1.0
	stats.Health = 15
	emit_signal('healthChanged', stats.Health)
	state = NORMAL


func _on_Timer_hit_timeout():
	if not atacking:  # Primeira ativação do timer. Habilitar animação de hit de espada
		$Sword_hitbox/CollisionShape2D.disabled = false
		$Sprite_hit_sword.visible = true
		atacking = true
		timer_sword_hit.start(sword_hit_duration)
	else:  # Segunda ativação do timer. Desabilitar a animação de hit da espada.
		$Sword_hitbox/CollisionShape2D.disabled = true
		$Sprite_hit_sword.visible = false
		atacking = false
		state = NORMAL

func shoot_power1():  # Atirar na esquerda e direita no dash do boss.
	if timer_shot_p1.time_left == 0:
		var bullet1 = Bullet.instance()
		bullet1.start(global_position, PI / 2)
		get_parent().get_parent().call_deferred('add_child', bullet1)
		var bullet2 = Bullet.instance()
		bullet2.start(global_position, -PI / 2)
		get_parent().get_parent().call_deferred('add_child', bullet2)
		timer_shot_p1.start()

func _on_Timer_power_1_timeout():
	if state == NORMAL:  # Começar o delay da investida.
		state = DELAY_POWER_1
		timer_power1.start(2)
	elif state == DELAY_POWER_1:  # Começar a investida.
		state = DASHING_POWER_1
		timer_power1.start(1)
	else:  # Boss está nocauteado ou dando um hit, reiniciar tentativa...
		timer_power1.start(3)
