extends Area2D

onready var timer = $Timer
var invincible = false setget set_invincible

signal inv_started
signal inv_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("inv_started")
	else:
		emit_signal("inv_ended")
		
func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func _on_Timer_timeout():
	self.invincible = false


func _on_HurtBox_inv_ended():
	call_deferred("set","monitorable",true)


func _on_HurtBox_inv_started():
	call_deferred("set","monitorable",false)
