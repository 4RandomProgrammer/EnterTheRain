extends RigidBody2D

const BULLET_SPEED = 500
var stunbullet = false

var Velocity = Vector2.ZERO
var direction = Vector2.ZERO


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Shot_body_entered(body):
	if body.has_method("stun_state") and stunbullet:
		body.stun_state()
	queue_free()
