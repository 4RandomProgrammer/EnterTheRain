extends "res://Assets/Enimies/Perseguidores/Enemy_chaser_base.gd"

func chase():
	if not enemy_range.target:  # Player saiu do range. Hora de mudar de estado
		state = pick_random_state([STOPED, RANDOM_WALKING])
	else:
		direction = global_position.direction_to(enemy_range.target.global_position)
		velocity = velocity.move_toward(direction * velocidade, velocidade / 2)
