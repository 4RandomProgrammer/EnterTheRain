extends Area2D

const BULLET_SPEED = 500
var DAMAGE = 0

var Velocity = Vector2.ZERO
var direction = Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):
	Velocity = BULLET_SPEED * delta * direction.normalized()
	translate(Velocity)
	
func shotdirection(dir):
	direction = dir

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Shot_area_entered(area):
	queue_free()
