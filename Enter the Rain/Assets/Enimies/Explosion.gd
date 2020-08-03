extends Area2D

export var DAMAGE = 1

func _on_Timer_timeout():
	queue_free()


func _on_Timer_damage_timeout():  # Desabilitar o dano da explosão após 0.1s
	$CollisionShape2D.disabled = true
