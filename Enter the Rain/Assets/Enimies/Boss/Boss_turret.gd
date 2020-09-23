extends KinematicBody2D

onready var rng = RandomNumberGenerator.new()
var damage = 1
onready var stats = $Stats
onready var laser_sprite = $Laser_sprite
onready var laser_hitbox = $Laser_hitbox/CollisionShape2D
onready var laser_timer = $Timer_laser
onready var laser_missile_timer = $Timer_missile_laser
onready var shoot_timer = $Timer_shoot
onready var player = get_parent().get_node('Player')
onready var Missile_shot = load('res://Assets/Enimies/Enemy_missile.tscn')
onready var Shield_machine = load('res://Assets/Enimies/Boss/Shield_machine.tscn')
onready var Big_bullet = load("res://Assets/Enimies/Enemy_bullet/SlowBigBullet.tscn")
onready var Explosion_target = load("res://Assets/Enimies/Mini_explosion_target.tscn")
var player_positions_list = []
var displaying_laser = false
var ang_player
var shield_machine_count = 0
var pulling_count = 0
var extra_explosions = 0
# Lista das posições das maquinas protetoras (relativas à posição do Boss).
var shield_machines_positions = [
	Vector2(500, 250),  # Canto inferior direito
	Vector2(500, -240),  # Canto superior direito
	Vector2(-400, 250),  # Canto inferior esquerdo
	Vector2(-400, -240)  # Canto superior esquerdo
]
enum {
	SPAWNING,
	NORMAL,
	LASER,
	PULLING,
	MANY_BULLETS
}
var state = SPAWNING

signal healthChanged(health)
signal Spawning(maxHealth)
signal Died

func _physics_process(delta):
	update()
	if is_instance_valid(player):
		match state:
			SPAWNING:
				pass
			NORMAL:
				rotate_turret()
				shoot()
			LASER:
				player_positions_list.append(player.global_position)
				if displaying_laser:
					rotation = (player_positions_list[0] - global_position).angle()
					player_positions_list.pop_front()
			PULLING:
				player.position -= (player.position - position).normalized()  # puxar player
				rotate_turret()
				shoot()
			MANY_BULLETS:
				var big_bullet = Big_bullet.instance()
				big_bullet.start(global_position, rng.randf_range(0, 360))
				get_parent().call_deferred('add_child', big_bullet)

func rotate_turret():
	ang_player = (player.position - position).angle()
	rotation = ang_player

func shoot():
	# Atirar na direção do player. As bullets recebem um incremento de -30° até 30° de angulo (pi / 6).
	if shoot_timer.time_left == 0:
		var big_bullet = Big_bullet.instance()
		big_bullet.start(global_position, ang_player + rng.randf_range(-PI / 6, PI / 6))
		get_parent().call_deferred('add_child', big_bullet)
		shoot_timer.start()

func _ready():
	position.y -= 125
	rng.randomize()
	# Conectando os sinais do HealthBar do boss
	var bossHealthBar = get_parent().get_node('Player').get_node('Camera2D').get_node('CanvasLayer').get_node('HealthBarBoss')
	var boss_turret = get_node('.')
	boss_turret.connect("Spawning", bossHealthBar, "_on_Boss_Spawning")
	boss_turret.connect("Died", bossHealthBar, "_on_Boss_Died")
	boss_turret.connect("healthChanged", bossHealthBar, "_on_Boss_healthChanged")
	emit_signal("Spawning", $Stats.MaxHealth)

func _draw():
	if shield_machine_count != 0:
		draw_arc(Vector2.ZERO, 50, 0, 360, 1000, ColorN('Green'))  # Desenhar escudo de proteção (circulo verde)
	if state == PULLING and is_instance_valid(player):
		draw_line(Vector2.ZERO, (player.position - position).rotated(-rotation), ColorN('Yellow')) # Desenhar laser que puxa.

func _on_HurtBox_area_entered(area):
	if state != SPAWNING and shield_machine_count == 0:
		var damage_taken = area.DAMAGE
		stats.Health -= damage_taken
		emit_signal("healthChanged", stats.Health)


func _on_Stats_no_health():
	emit_signal('Died')
	queue_free()


func _on_Timer_spawn_timeout():
	shoot_timer.start()
	state = NORMAL

func _on_Timer_change_pow_timeout():
	choose_power()

func choose_power():
	var power_choosen = rng.randi_range(1, 4)
	if power_choosen == 1:
		# Poder 1: Raio laser. Ação: Iniciar os timers referentes a esse poder e mudar o estado
		state = LASER
		laser_timer.start(0.3)
		laser_missile_timer.start(0.4)
	elif power_choosen == 2:
		# Poder 2: Torres protetoras. Ação: Spawnar as torres protetoras
		if shield_machine_count == 0:
			for shield_machine_pos in shield_machines_positions:
				var shield_machine = Shield_machine.instance()
				shield_machine.position = global_position + shield_machine_pos
				get_parent().call_deferred('add_child', shield_machine)
			shield_machine_count = 4
		else:  # As maquinas protetoras ainda estão vivas... Escolher outro poder.
			choose_power()
	elif power_choosen == 3:
		# Poder 3: Puxao e explosoes. Ação: começar a puxar o player para a direção da torre e fazer algumas explosões.
		state = PULLING
		$Timer_pulling.start()
	else:
		# Poder 4: Tiro para todos os lados !
		$Timer_many_bullets.start()
		state = MANY_BULLETS


func _on_Timer_laser_timeout():  # Power 1
	if not displaying_laser:
		# Ativar o laser por 5 secs
		laser_sprite.visible = true
		laser_hitbox.disabled = false
		displaying_laser = true
		laser_timer.start(5)
	else:
		# Hora de desativar o laser
		laser_sprite.visible = false
		laser_hitbox.disabled = true
		displaying_laser = false
		state = NORMAL
		player_positions_list.clear()
		laser_missile_timer.stop()


func _on_Timer_missile_laser_timeout():  # Atirando misseis durante poder 1
	# Soltar um missil e começar a contagem novamente...
	if is_instance_valid(player):
		var missile = Missile_shot.instance()
		missile.start(global_position, (player.position - position).angle())
		get_parent().call_deferred('add_child', missile)
		laser_missile_timer.start(rng.randf_range(0.5, 1.75))


func _on_Timer_pulling_timeout():  # Power 3
	if pulling_count != 4 and is_instance_valid(player):
		var current_angle = 0
		var target_position = (player.position - position).normalized() * (50 + 100 * extra_explosions)
		while current_angle <= 2 * PI:
			spawn_target_explosion(position + target_position.rotated(current_angle))
			current_angle += PI / 10 / (extra_explosions + 1)
		extra_explosions += 1
		if extra_explosions == 6:
			extra_explosions = 0
			pulling_count += 1
		$Timer_pulling.start()
	else:
		state = NORMAL
		pulling_count = 0


func spawn_target_explosion(target_pos):
	var Target = Explosion_target.instance()
	Target.position = target_pos
	Target.explosion_timer = 1
	get_parent().call_deferred('add_child', Target)


func _on_Timer_many_bullets_timeout():
	state = NORMAL
