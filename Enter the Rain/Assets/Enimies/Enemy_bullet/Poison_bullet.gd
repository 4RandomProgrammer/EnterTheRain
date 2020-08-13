extends 'res://Assets/Enimies/Enemy_bullet/EnemyBullet.gd'
onready var poison = load('res://Assets/Enimies/Veneno.tscn')

func on_collision():
	var Poison = poison.instance()
	Poison.position = position
	get_parent().call_deferred('add_child', Poison)


func _on_Timer_explode_poison_timeout():
	var Poison = poison.instance()
	Poison.position = position
	get_parent().call_deferred('add_child', Poison)
	queue_free()
