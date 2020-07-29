extends RigidBody2D

func _ready():
	$Timer.start(15)


func _on_Timer_timeout():
	queue_free()
