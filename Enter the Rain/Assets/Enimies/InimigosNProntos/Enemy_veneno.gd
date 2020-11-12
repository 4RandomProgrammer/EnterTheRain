extends "res://Assets/Enimies/InimigosNProntos/Enemy_attack_base.gd"

var attacking = false

const VENENO = preload("res://Assets/Enimies/Poison.tscn")

func _on_AttackDuration_timeout():
	if not can_attack:
		var poison = VENENO.instance()
		rotation = (enemy_range.target.position - position).angle()
		poison.position = enemy_range.target.position
		can_attack = true
		attackduration.start(attack_cooldown)
		get_parent().add_child(poison)
	else:
		
		can_attack = false
		
		if enemy_range.entity_aimed():
			state = CHASING
		else:
			state = RANDOM_WALKING

func chase():
	direction = global_position.direction_to(enemy_range.target.global_position)
	velocity = velocity.move_toward(direction * velocidade, velocidade / 2)
