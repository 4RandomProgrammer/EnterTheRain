extends Area2D

export (int)var speed
var velocity = Vector2()
export var DAMAGE = 1
var collision_body
var can_disapear = true

func start(pos, dir):
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)

func _physics_process(delta):
	position += velocity * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Area2D_body_entered(body):
	collision_body = body  # Salvando o colisor em uma variavel(sera utilizado para o superbullet)
	on_collision()
	if can_disapear:
		queue_free()


func on_collision():
	pass
