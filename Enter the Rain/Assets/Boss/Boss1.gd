extends KinematicBody2D

onready var velocity = 100
onready var directions = [Vector2(velocity, velocity), Vector2(- velocity, - velocity),
						Vector2(- velocity, velocity), Vector2(velocity, - velocity)]
onready var timer_stop = $Timer_parar
onready var timer_walk = $Timer_andar
onready var enemy_bullet = load("res://Assets/Enemy_bullet/EnemyBullet.tscn")
onready var stats = $Stats
onready var boss_range = $Alcance
onready var screen_verification = $VisibilityNotifier2D
onready var rng = RandomNumberGenerator.new()
var angle_pat_1 = 0
enum {
	POWER_1
	WALKING
}
var state = WALKING
var target
var can_shoot = true


func _ready():
	rng.randomize()
	velocity = directions[rng.randi_range(0, 3)]


func _physics_process(delta):
	if screen_verification.is_on_screen:
		try_aim_player()
		match state:
			WALKING:
				var collision = move_and_collide(velocity * delta)
				if collision:
					velocity = velocity.bounce(collision.normal)  # Toda vez que bater em algo, rebater.
			POWER_1:
				power_1()


func shoot(pos):  # Atirar no player.
	var bullet = enemy_bullet.instance()
	var dir = (pos - global_position).angle() 
	bullet.start(global_position, dir + rand_range(-0.05, 0.05))
	get_parent().add_child(bullet)
	can_shoot = false
	$Bullet_timer.start()

func power_1():
	var current_dir = 0
	angle_pat_1 += 0.01  # Rotação.
	while current_dir < 2 * PI:  # Adicionar 90° (pi/2) a cada loop. Isso criará bullets nas 4 direções.
		var bullet_pat_1 = enemy_bullet.instance()
		bullet_pat_1.start(global_position, current_dir + angle_pat_1)
		get_parent().add_child(bullet_pat_1)
		current_dir += PI / 2


func try_aim_player():  # Tentar atirar no player se tiver no range e sem obstaculos na frente.
	if boss_range.player_aimed():
		if can_shoot:
			shoot(boss_range.target.position)


func _on_Timer_parar_timeout():  # Começar a andar novamente por 10s.
	velocity = directions[rng.randi_range(0, 3)]
	timer_walk.start(10)
	state = WALKING


func _on_Timer_andar_timeout():  # Parar por 5s.
	timer_stop.start(5)
	state = POWER_1


func _on_Stats_no_health():
	queue_free()


func _on_HurtBox_area_entered(area):
	var damage = area.DAMAGE
	stats.Health -= damage


func _on_Bullet_timer_timeout():
	can_shoot = true


func _on_StunTimer_timeout():
	state = WALKING
