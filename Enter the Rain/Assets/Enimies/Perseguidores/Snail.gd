extends "res://Assets/Enimies/Perseguidores/Enemy_chaser_base.gd"

const VENENO = preload("res://Assets/Enimies/Poison.tscn")

export var poisontime = 0.2
var can_poison = false

func chase():
	if can_poison:
		var poison = VENENO.instance()
		rotation = (enemy_range.target.position + position).angle()
		poison.position = position
		can_poison = false
		get_parent().add_child(poison)
	elif $PoisonTimer.is_stopped():  # O timer acabou, recomeçar a contagem para o proximo tiro.
		$PoisonTimer.start(poisontime)
	
	direction = -(global_position.direction_to(enemy_range.target.global_position))
	velocity = velocity.move_toward(direction * velocidade, velocidade / 2)


func _on_PoisonTimer_timeout():
	can_poison = true
