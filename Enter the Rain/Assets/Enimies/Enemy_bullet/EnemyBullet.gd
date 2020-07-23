extends Area2D

export var speed = 700
var velocity = Vector2()
export var DAMAGE = 1

func start(pos, dir):
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)

func _physics_process(delta):
	position += velocity * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Area2D_body_entered(_body):
	queue_free()
