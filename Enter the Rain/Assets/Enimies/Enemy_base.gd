extends KinematicBody2D

onready var stats = get_node("Stats")


func _on_Stats_no_health():
	# Chamada quando o inimigo morrer, player receberá dinheiro e o inimigo sumirá.
	get_parent().get_node("Player").player_killed_enemy(position)
	queue_free()


func _on_HurtBox_area_entered(area):
	var damage_taken = area.DAMAGE
	stats.Health -= damage_taken

