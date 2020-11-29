extends "res://Assets/Enimies/Enemy_base.gd"

var damage = 1
var velocidade = 100
var velocity = Vector2.ZERO
onready var Minion_range = $Range
onready var shoot_timer = $Shoot_timer
onready var poison_bullet = load('res://Assets/Enimies/Enemy_bullet/Poison_bullet.tscn')
onready var explosion = load("res://Assets/Enimies/Explosion.tscn")

func _ready():
	shoot_timer.start(rand_range(1, 4))

func _physics_process(delta):
	if Minion_range.entity_aimed():
		var direction = global_position.direction_to(Minion_range.target.global_position)
		velocity = velocity.move_toward(direction * velocidade * delta, velocidade / 2 * delta)
		move_and_collide(velocity)

func _on_Shoot_timer_timeout():
	if Minion_range.entity_aimed():
		var bullet = poison_bullet.instance()
		bullet.start(global_position, (Minion_range.target.global_position - position).angle())
		get_parent().call_deferred('add_child', bullet)
		shoot_timer.start(rand_range(1, 4))

func on_death():
	var Explosion = explosion.instance()
	Explosion.position = position
	get_parent().call_deferred('add_child', Explosion)
