extends Area2D

onready var explosion = $Explosion/ExplosionArea
var Movement  = Vector2()
var direction = Vector2.RIGHT
var collided = 0

const BULLETSPEED = 300

func _ready():
	$Timer.start()

func _physics_process(delta):
	match collided:
		0:
			Movement = BULLETSPEED * direction.normalized() * delta
		
	
		1:
			Movement = Vector2.ZERO
	
	translate(Movement)
	
func shotdir(direct):
	direction = direct


func _on_Granada_body_entered(body):
	collided = 1
	explosion.call_deferred("set","disabled", false)
	$AnimationPlayer.play("Explosion")

func _on_AnimationPlayer_animation_finished(Explosion):
	queue_free()


func _on_Timer_timeout():
	collided = 1
	explosion.call_deferred("set","disabled", false)
	$AnimationPlayer.play("Explosion")
