extends "res://Assets/Enimies/Perseguidores/Enemy_chaser_base.gd"

var can_attack = true

func chase():
	direction = global_position.direction_to(enemy_range.target.global_position)
	velocity = velocity.move_toward(direction * velocidade, velocidade / 2)


func _on_melee_range_body_entered(body):
	move_and_slide(Vector2.ZERO)
	if enemy_range.entity_aimed():
		rotation = (enemy_range.target.position - position).angle()
		if can_attack:
			attack()
	else:
		can_attack = false
		$Timer.start()
	

func attack():
	$Position2D/Hitbox2/CollisionShape2D.set_deferred("disabled", false)
	

func _on_Timer_timeout():
	can_attack = true


func _on_AtackTimer_timeout():
	pass # Replace with function body.
