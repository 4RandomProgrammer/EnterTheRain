extends "res://Assets/Enimies/Enemy_base.gd"

var damage = 1
var player
var velocidade = 100
var velocity = Vector2.ZERO
onready var shoot_timer = $Shoot_timer
onready var poison_bullet = load('res://Assets/Enimies/Enemy_bullet/Poison_bullet.tscn')
onready var explosion = load("res://Assets/Enimies/Explosion.tscn")

func _ready():
	shoot_timer.start(rand_range(1, 4))

func _physics_process(delta):
	if is_instance_valid(player):
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * velocidade * delta, velocidade / 2 * delta)
		move_and_collide(velocity)

func _on_Shoot_timer_timeout():
	if is_instance_valid(player):
		var bullet = poison_bullet.instance()
		bullet.start(global_position, (player.position - position).angle())
		get_parent().call_deferred('add_child', bullet)
		shoot_timer.start(rand_range(1, 4))

func on_death():
	var Explosion = explosion.instance()
	Explosion.position = position
	get_parent().call_deferred('add_child', Explosion)
