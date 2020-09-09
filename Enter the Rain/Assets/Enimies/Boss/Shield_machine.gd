extends StaticBody2D

var damage = 1
onready var Boss_turret = get_parent().get_node('Boss')
onready var Explosion = load('res://Assets/Enimies/Explosion.tscn')

func _draw():
	var final_protect_laser_pos = (Boss_turret.position - position)
	# Arrumando a posição final do laser (para não ficar em cima do boss)
	if final_protect_laser_pos.x > 0:
		final_protect_laser_pos.x -= 33
	else:
		final_protect_laser_pos.x += 33
	if final_protect_laser_pos.y > 0:
		final_protect_laser_pos.y -= 33
	else:
		final_protect_laser_pos.y += 33
	draw_line(Vector2.ZERO, final_protect_laser_pos, ColorN('Green'))

func _on_HurtBox_area_entered(area):
	$Stats.Health -= area.DAMAGE

func _on_Stats_no_health():
	var explosion = Explosion.instance()
	explosion.position = position
	get_parent().call_deferred('add_child', explosion)
	Boss_turret.shield_machine_count -= 1
	queue_free()
