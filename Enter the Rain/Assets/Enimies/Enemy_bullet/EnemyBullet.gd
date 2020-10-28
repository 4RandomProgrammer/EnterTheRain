extends Area2D

export (int)var speed
var velocity = Vector2()
export var DAMAGE = 1
var collision_body
var can_disapear = true
onready var timer_duration = $Timer_duration

func start(pos, dir):
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)

func _physics_process(delta):
	on_pysics_loop(delta)
	position += velocity * delta


func _on_Area2D_body_entered(body):
	collision_body = body  # Salvando o colisor em uma variavel(sera utilizado para o superbullet)
	on_collision()
	if can_disapear:
		queue_free()


func on_collision():
	pass

func _on_Timer_duration_timeout():
	timer_finished()
	queue_free()

func timer_finished():
	pass

func on_pysics_loop(_delta):
	pass
