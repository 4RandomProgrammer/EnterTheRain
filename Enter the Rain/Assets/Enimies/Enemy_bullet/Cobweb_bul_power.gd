extends 'res://Assets/Enimies/Enemy_bullet/Cobweb_bullet.gd'
var teias_laterais = 0


func _on_Timer_timeout():
	teias_laterais = teias_laterais + teias_laterais / 2 + 2
	for i in range(teias_laterais):
		var cobweb = Cob_web.instance()
		cobweb.position = global_position + Vector2(32 * (i + 1), 0).rotated(90 + rotation)
		get_parent().call_deferred('add_child', cobweb)
