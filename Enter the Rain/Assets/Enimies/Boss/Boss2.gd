extends KinematicBody2D

onready var random_moviment = $Movimento_aletorio
var direction
var speed = 100
var velocity = Vector2.ZERO
var damage = 1

func _physics_process(delta):
	direction = global_position.direction_to(random_moviment.target_position)  # Pegar posic. aleatória do modulo 'movimento_aleatorio'
	velocity = velocity.move_toward(direction * speed * delta, speed * delta)
	var collision = move_and_collide(velocity)
	if global_position.distance_to(random_moviment.target_position) <= 10:
		random_moviment.update_target_position()
	if collision:
		print('mudou')
		random_moviment.update_target_position()
