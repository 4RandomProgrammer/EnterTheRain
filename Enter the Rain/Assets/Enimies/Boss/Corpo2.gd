extends KinematicBody2D
var velocity = Vector2(175, 0)
var damage = 1
var angle = 90
var slowing = false
var started = false
var velocity_snake_body = Vector2.ZERO
var change_dir = false

func _physics_process(delta):
	move_and_collide(-get_parent().velocity_snake_mov.rotated(get_parent().angle) * delta)
	if started:
		if slowing:
			velocity_snake_body -= velocity * 0.02
		else:
			velocity_snake_body += velocity * 0.02
	move_and_collide(velocity_snake_body.rotated(angle) * delta)


func _on_Timer_start_timeout():
	started = true
	$Timer_mov_body.start()
	$Timer_parar_body.start()


func _on_Timer_mov_body_timeout():
	velocity_snake_body = Vector2.ZERO
	if change_dir:
		angle = 90
		change_dir = false
	else:
		angle = -90
		change_dir = true


func _on_Timer_parar_body_timeout():
	if slowing:
		slowing = false
	else:
		slowing = true
