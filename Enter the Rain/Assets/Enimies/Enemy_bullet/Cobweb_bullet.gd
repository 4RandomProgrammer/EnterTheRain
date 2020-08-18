extends 'res://Assets/Enimies/Enemy_bullet/EnemyBullet.gd'
onready var cob_web = load("res://Assets/Enimies/Teia.tscn")
onready var Poison = load('res://Assets/Enimies/Poison.tscn')


func _on_Timer_teia_timeout():  # Criar rastro de teia
	var Cobweb = cob_web.instance()
	Cobweb.position = position
	get_parent().call_deferred('add_child', Cobweb)

func on_collision():
	var poison = Poison.instance()
	poison.position = position
	get_parent().call_deferred('add_child', poison)
