extends KinematicBody2D

onready var random_moviment = $Movimento_aletorio
onready var missile = load('res://Assets/Enimies/Enemy_missile.tscn')
onready var explosive_bullet = load("res://Assets/Enimies/Enemy_bullet/Explosive_bullet.tscn")
onready var super_explosive_bullet = load("res://Assets/Enimies/Enemy_bullet/SuperExplosiveBullet.tscn")
onready var enemy_bullet = load("res://Assets/Enimies/Enemy_bullet/EnemyBullet.tscn")
onready var boss_range = $Range
onready var arena_boss_2 = load("res://Assets/Spawners/BossSpawner/ArenaBoss2.tscn")
onready var target_resource = load('res://Assets/Enimies/Explosion_target.tscn')
var already_used_power1 = false
var boss_2
var rng = RandomNumberGenerator.new()
var direction
var speed = 100
var arena_pos
onready var stats = $Stats
onready var shoot_timer  = $Shoot_timer
var velocity = Vector2.ZERO
var damage = 1
var can_shoot = false
var last_pos
var target_pos_pow2
var target_instance
enum {
	SPAWNING,
	WALKING,
	POWER1,
	POWER2
}
var state = SPAWNING

signal healthChanged(health)
signal Spawning(maxHealth, boss_name)
signal Died


func _ready():
	rng.randomize()
	var bossHealthBar = get_parent().get_node('Player').get_node('Camera2D').get_node('CanvasLayer').get_node('HealthBarBoss')
	arena_pos = Vector2(position.x, position.y + 100)
	boss_2 = get_node('.')
	connect("Spawning", bossHealthBar, "_on_Boss_Spawning")
	connect("Died", bossHealthBar, "_on_Boss_Died")
	connect("healthChanged", bossHealthBar, "_on_Boss_healthChanged")
	emit_signal("Spawning", $Stats.MaxHealth, 'Explosivo')


func _physics_process(delta):
	match state:
		SPAWNING:
			$Sprite.self_modulate.r = 0.2
		WALKING:
			movimentation(delta)
			aim_player()
		POWER1:
			if boss_range.entity_aimed():
				last_pos = boss_range.target.position
				rotation = (last_pos - position).angle()
			if $Timer_pow1.time_left == 0:
				var super_bullet = super_explosive_bullet.instance()
				if last_pos:
					super_bullet.start(global_position, (last_pos - position).angle())
				else:
					super_bullet.start(global_position, rng.randi_range(0, 360))
				get_parent().call_deferred('add_child', super_bullet)
				last_pos = null
				state = WALKING
		POWER2:
			while not target_pos_pow2:
				var space_state = get_world_2d().direct_space_state
				random_moviment.update_target_position()
				if not space_state.intersect_ray(position, random_moviment.target_position, [self], collision_mask):  # Verificar se tem parede no caminho
					target_pos_pow2 = random_moviment.target_position
					target_instance = target_resource.instance()
					target_instance.position = target_pos_pow2
					get_parent().call_deferred('add_child', target_instance)
			if $Timer_pow2.time_left == 0:  # Hora da investida !
				direction = global_position.direction_to(target_pos_pow2)
				velocity = velocity.move_toward(direction * (speed + 500) * delta, (speed + 500) * delta)
				var collision = move_and_collide(velocity)
				if global_position.distance_to(target_pos_pow2) <= 10 or collision:
					var dir_bullet = 0
					while dir_bullet < 2 * PI:
						var bullet_spawn = explosive_bullet.instance()
						bullet_spawn.start(global_position, dir_bullet)
						get_parent().call_deferred('add_child', bullet_spawn)
						dir_bullet += PI / 5
					state = WALKING
					target_pos_pow2 = null
					target_instance.queue_free() # Tirar a marcação


func movimentation(delta):
	direction = global_position.direction_to(random_moviment.target_position)  # Pegar posic. aleatória do modulo 'movimento_aleatorio'
	velocity = velocity.move_toward(direction * speed * delta, speed * delta)
	var collision = move_and_collide(velocity)
	if global_position.distance_to(random_moviment.target_position) <= 10 or collision:
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
		emit_signal('healthChanged', stats.Health)
		if stats.Health <= stats.MaxHealth / 2 and not already_used_power1:
			# Metade da vida... Sumir e começar a explodir a arena toda por um tempo !
			var Arena = arena_boss_2.instance()
			Arena.position = arena_pos
			Arena.boss_2 = boss_2
			get_parent().call_deferred('add_child', Arena)
			already_used_power1 = true
			get_parent().remove_child(boss_2)

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
	emit_signal("Died")
	queue_free()


func _on_Shoot_timer_timeout():
	can_shoot = true


func _on_Timer_power_timeout():
	$Timer_power.start(rand_range(3, 8))
	if rng.randi_range(2, 3) == 2:  # Soltar o super BULLET
		$Timer_pow1.start()
		state = POWER1
	else:
		$Timer_pow2.start()
		state = POWER2


func _on_Timer_spawning_timeout():
	state = WALKING
	$Timer_power.start(rand_range(3, 8))
	$Shoot_timer.start()
	$Missile_timer.start(rng.randf_range(0, 5))
	$Sprite.self_modulate.r = 1.0
