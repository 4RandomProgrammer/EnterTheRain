extends KinematicBody2D

export (int)var speed
var velocity = Vector2.ZERO
var alreay_colided = false

func start(pos, dir):
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if alreay_colided:
			queue_free()
		velocity = velocity.bounce(collision.normal)
		alreay_colided = true


func _on_Timer_duration_timeout():
	queue_free()


func _on_Area2D_body_entered(body):
	queue_free()
