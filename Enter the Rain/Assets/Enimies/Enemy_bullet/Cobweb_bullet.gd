extends 'res://Assets/Enimies/Enemy_bullet/EnemyBullet.gd'
onready var Cob_web = load("res://Assets/Enimies/Teia.tscn")
onready var Poison = load('res://Assets/Enimies/Poison.tscn')


func _on_Timer_teia_timeout():  # Criar rastro de teia
	var cobweb = Cob_web.instance()
	cobweb.position = position
	get_parent().call_deferred('add_child', cobweb)

func on_collision():  # Ao colidir, soltar veneno.
	var poison = Poison.instance()
	poison.position = position
	get_parent().call_deferred('add_child', poison)
