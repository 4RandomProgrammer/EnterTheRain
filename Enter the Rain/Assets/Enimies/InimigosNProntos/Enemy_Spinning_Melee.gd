extends "res://Assets/Enimies/InimigosNProntos/Enemy_attack_Base.gd"

func chase():
	direction = global_position.direction_to(enemy_range.target.global_position)
	velocity = velocity.move_toward(direction * velocidade, velocidade / 2)

func _on_AttackDuration_timeout():
	if not can_attack:
		$Hitbox2/CollisionShape2D.set_deferred("disabled", false)
		$Anim.play("Spin")
		can_attack = true
		attackduration.start(attack_cooldown * 5)
		$Attack_Range/CollisionShape2D.set_deferred("disabled", true)
		
	else:
		$Hitbox2/CollisionShape2D.set_deferred("disabled", true)
		can_attack = false
		$Attack_Range/CollisionShape2D.set_deferred("disabled", false)
		$Anim.stop()
		
	if enemy_range.entity_aimed():
		state = CHASING
	else:
		state = RANDOM_WALKING
