extends Area2D

const BULLET_SPEED = 500
var Velocity = Vector2.ZERO
var direction = 1

func _physics_process(delta):
	Velocity.x = BULLET_SPEED * delta * direction
	translate(Velocity)
	
func shotdirection(dir):
	direction = dir
	if dir == -1:
		$Sprite.flip_h = true

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
