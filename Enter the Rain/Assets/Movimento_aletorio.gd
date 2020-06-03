extends Node2D

export (int) var alcance_posic_aleatoria = 100

onready var timer = $Timer
onready var target_position = global_position
onready var start_position = global_position

func update_target_position():  # Escolher posic. aleatória(dentro da área) para o inimigo ir.
	var target_vector = Vector2(rand_range(- alcance_posic_aleatoria, alcance_posic_aleatoria), rand_range(- alcance_posic_aleatoria, alcance_posic_aleatoria))
	target_position = start_position + target_vector

func get_time_left():
	return timer.time_left

func start_wander_timer(duration):
	timer.start(duration)

func _on_Timer_timeout():
	update_target_position()
