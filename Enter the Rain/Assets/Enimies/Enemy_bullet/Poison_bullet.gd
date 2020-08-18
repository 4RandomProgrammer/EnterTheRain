extends 'res://Assets/Enimies/Enemy_bullet/EnemyBullet.gd'
onready var Poison = load('res://Assets/Enimies/Poison.tscn')

func on_collision():
	var poison = Poison.instance()
	poison.position = position
	get_parent().call_deferred('add_child', poison)


func _on_Timer_explode_poison_timeout():
	var poison = Poison.instance()
	poison.position = position
	get_parent().call_deferred('add_child', poison)
	queue_free()
