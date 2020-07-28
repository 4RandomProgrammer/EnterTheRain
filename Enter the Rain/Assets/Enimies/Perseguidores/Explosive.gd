extends "res://Assets/Enimies/Perseguidores/Enemy_chaser_base.gd"
onready var explosive_run = "res://Assets/Enimies/Perseguidores/Explosivo2.png"
onready var explosion = load("res://Assets/Enimies/Perseguidores/Explosion.tscn")
onready var explosion_run_sprite = load("res://Assets/Enimies/Perseguidores/Explosivo2.png")
var started_explosive_run = false

func chase():
	if not enemy_range.target and not started_explosive_run:  # Player saiu do range. Hora de mudar de estado
		state = pick_random_state([STOPED, RANDOM_WALKING])
	else:
		direction = global_position.direction_to(enemy_range.target.global_position)
		velocity = velocity.move_toward(direction * velocidade, velocidade / 2)


func _on_explosion_chase_body_entered(body):
	if enemy_range.entity_aimed():
		started_explosive_run = true
		velocidade = 300
		$Sprite.texture = explosion_run_sprite
		$Explosion_timer.start()


func _on_Explosion_timer_timeout():
	var explosion_inst = explosion.instance()
	explosion_inst.position = position
	get_parent().add_child((explosion_inst))
	queue_free()
