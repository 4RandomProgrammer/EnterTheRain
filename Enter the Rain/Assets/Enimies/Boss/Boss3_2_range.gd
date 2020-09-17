extends KinematicBody2D

onready var player = get_parent().get_parent().get_node('Player')
onready var stats = $Stats_range
onready var timer_shot = $Timer_shot
onready var Bullet = load("res://Assets/Enimies/Enemy_bullet/SlowBigBullet.tscn")
enum {
	SPAWNING,
	NORMAL,
	TELEPORTING,
	KNOCKED
}
var initial_pos
var state = SPAWNING
var player_is_near = false
var damage = 1
var speed = 200
var velocity = Vector2.ZERO

signal Spawning
signal healthChanged
signal Died


func _ready():
	initial_pos = Vector2(position.x - 75, position.y)
	# Conectando os sinais:
	var bossHealthBar2 = get_parent().get_parent().get_node('Player').get_node('Camera2D').get_node('CanvasLayer').get_node('HealthBarBoss2')
	connect("Spawning", bossHealthBar2, "_on_Boss_Spawning")
	connect("healthChanged", bossHealthBar2, "_on_Boss_healthChanged")
	emit_signal("Spawning", stats.MaxHealth)

func _physics_process(delta):
	update()
	match state:
		NORMAL:
			shoot()
			if player_is_near:
				var direction = global_position.direction_to(player.position)
				velocity = velocity.move_toward(direction * speed * delta, speed / 2)
				var collide = move_and_collide(-velocity)
				if collide:
					state = TELEPORTING
					$Timer_teleport.start()

func shoot():
	if timer_shot.time_left == 0 and is_instance_valid(player):
		var bullet = Bullet.instance()
		bullet.start(global_position, (player.position - global_position).angle() + rand_range(-PI/6, PI/6))
		get_parent().get_parent().call_deferred("add_child", bullet)
		timer_shot.start()

func _draw():
	if state == TELEPORTING:
		draw_circle(Vector2.ZERO, 50, ColorN('Purple'))

func _on_HurtBox_area_entered(area):
	if state != KNOCKED and state != SPAWNING:
		var damage_taken = area.DAMAGE
		stats.Health -= damage_taken
		emit_signal('healthChanged', stats.Health)

func _on_Timer_spawn_timeout():
	state = NORMAL

func _on_Stats_range_no_health():
	state = KNOCKED
	$Sprite.self_modulate.r = 0.2

func revive():
	$Sprite.self_modulate.r = 1.0
	stats.Health = 15
	emit_signal('healthChanged', stats.Health)
	state = NORMAL


func _on_Area_find_player_body_entered(body):
	player_is_near = true

func _on_Area_find_player_body_exited(body):
	player_is_near = false

func _on_Timer_teleport_timeout():
	if position.x < initial_pos.x:  # Boss bateu na parede mais a esquerda
		position = Vector2(initial_pos.x + 50 + rand_range(0, 50), initial_pos.y + rand_range(-25, 50))
	else:
		position = Vector2(initial_pos.x - 50 - rand_range(0, 50), initial_pos.y + rand_range(-25, 50))
	state = NORMAL
		
