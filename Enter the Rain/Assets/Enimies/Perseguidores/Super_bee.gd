extends "res://Assets/Enimies/Perseguidores/Enemy_chaser_base.gd"
var Bee = load('res://Assets/Enimies/Perseguidores/Bee_enemy.tscn')
var rng = RandomNumberGenerator.new()

func chase():
	direction = global_position.direction_to(enemy_range.target.global_position)
	velocity = velocity.move_toward(direction * velocidade, velocidade / 2)


func _on_Timer_spawn_timeout():
	rng.randomize()
	if screen_verification.is_on_screen:
		for i in range(rng.randi_range(1, 2)):
			var bee = Bee.instance()
			bee.position = global_position + Vector2(rng.randf_range(-64, 64), rng.randf_range(-64, 64))
			bee.min_money = 0
			bee.max_money = 0
			get_parent().call_deferred('add_child', bee)
