extends KinematicBody2D


onready var Stats = $Stats
onready var Timer_shoot = $Timer_shoot
onready var Timer_power = $Timer_power
onready var Final_boss_bullet = load("res://Assets/Enimies/Enemy_bullet/FinalBossBullet.tscn")
onready var Bullet = load("res://Assets/Enimies/Enemy_bullet/SlowBigBullet.tscn")
onready var Missile = load("res://Assets/Enimies/Enemy_missile.tscn")
onready var Current_bullet = Bullet
onready var rng = RandomNumberGenerator.new()

enum {
	SPAWNING,
	NORMAL
}
var reload_time = 0.8
var state = SPAWNING
var protected = true
var power_max_reload = 20
var power_min_reload = 10
var quant_misseis = 1

signal Cientista_damaged(health)


func _physics_process(delta):
	update()
	match state:
		NORMAL:
			shoot()

func shoot():
	if Timer_shoot.time_left == 0:
		var bullet = Current_bullet.instance()
		bullet.start(global_position, PI / 2 + rand_range(-PI/3, PI/3))
		get_parent().get_parent().call_deferred('add_child', bullet)
		Timer_shoot.start(reload_time)


func _draw():
	if protected:  # Desenhar escudo se as torres ainda tiverem vivas.
		draw_arc(Vector2.ZERO, 50, 0, 360, 1000, ColorN('Green'))


func _on_HurtBox_area_entered(area):
	if not protected:
		var damage_taken = area.DAMAGE
		Stats.Health -= damage_taken
		emit_signal("Cientista_damaged", Stats.Health)


func _on_Timer_spawn_timeout():
	state = NORMAL


func _on_Stats_no_health():  # Buffar boss quando alguma torre morrer 
	reload_time -= 0.2
	power_min_reload -= 0.2
	power_max_reload -= 0.2
	quant_misseis += 1


func _on_Timer_power_timeout():
	var poder_selecionado = rng.randi_range(1, 2)
	if poder_selecionado == 1:
		# Trocar os tiros comuns por tiros explosivos com bullets que voltam, por 5 secs.
		Current_bullet = Final_boss_bullet
		$Timer_pow1.start()
	elif poder_selecionado == 2:
		# Soltar os misseis
		for i in range(quant_misseis):
			spawn_missile()
	Timer_power.start(rand_range(power_min_reload, power_max_reload))

func _on_Timer_pow1_timeout():
	Current_bullet = Bullet

func spawn_missile():
	var missile = Missile.instance()
	missile.start(global_position, rand_range(-PI/3, PI/3))
	get_parent().get_parent().call_deferred('add_child', missile)
