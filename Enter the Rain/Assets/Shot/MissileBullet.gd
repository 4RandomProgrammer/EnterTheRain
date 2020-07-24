extends Area2D

var velocity = Vector2()
export var DAMAGE = 1
var speed
onready var missile_range = $Range

func start(pos, dir):
	position = pos
	rotation = dir
	speed = 300
	velocity = Vector2(speed, 0).rotated(dir)

func _physics_process(delta):
	position += velocity * delta
	if missile_range.entity_aimed():
		velocity += chase()
		rotation = velocity.angle()


func chase():  # Retorna vetor que corrigi a direção do missil
	var desired_velocity = (missile_range.target.position - position).normalized() * speed
	var rotate_speed = (desired_velocity - velocity).normalized() * 10
	return rotate_speed


func _on_VisibilityNotifier2D_screen_exited():  # Saiu da tela
	queue_free()


func _on_Area2D_body_entered(_body):  # acertou algum alvo
	queue_free()
