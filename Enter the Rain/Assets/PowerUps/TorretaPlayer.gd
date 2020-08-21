extends KinematicBody2D

const Bullet = preload("res://Assets/Shot/Shot.tscn")
onready var turret_range = $Range
onready var stats = $Stats
var can_shoot = true

signal Spawned
signal dead

func _ready():
	connect("dead",get_parent().get_node("Player"),"turret_dead")
	emit_signal("Spawned")

func _physics_process(_delta):
	update()
	try_aim_player_and_shoot()

func try_aim_player_and_shoot():  # Função que tentará atirar no player. Só atirará quando tiver no range e sem obstaculos na frente.
	if turret_range.entity_aimed():
		rotation = (turret_range.target.position - position).angle()
		if can_shoot:
			shoot(turret_range.target.position)
	else:  # Resetar o timer se o player não estiver na mira (faz com que a torre não atire imediatamente)
		can_shoot = false
		$ShootTimer.start()

func shoot(pos):  # Função que atira na direção do player.
	var bullet = Bullet.instance()
	var angle = (pos - global_position).angle()
	bullet.apply_impulse(Vector2(), Vector2(bullet.BULLET_SPEED, 0).rotated(angle))
	bullet.global_position = global_position
	get_parent().add_child(bullet)
	can_shoot = false  # Após um tiro, deve-se dar um delay para o próximo tiro.
	$ShootTimer.start()


func _on_Stats_no_health():
	emit_signal("dead")
	queue_free()


func _on_HurtBox_area_entered(area):
	if $HurtBox/Timer.is_stopped():
		$HurtBox/Timer.start(0.4)
		stats.Health -= area.DAMAGE


func _on_ShootTimer_timeout():
	can_shoot = true
