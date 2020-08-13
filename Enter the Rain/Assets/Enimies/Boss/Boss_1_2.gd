extends Node2D
var speed = 150
var damage = 1
var state = 'Spawning'
var min_timer = 1
var max_timer = 3
var probability_super_bullet = 5

signal Spawning
signal Died
signal healthChanged

func _ready():
	var bossHealthBar = get_parent().get_node('Player').get_node('Camera2D').get_node('CanvasLayer').get_node('HealthBarBoss')
	var boss_1_2 = get_node('.')
	boss_1_2 = get_node('.')
	boss_1_2.connect("Spawning", bossHealthBar, "_on_Boss_Spawning")
	boss_1_2.connect("Died", bossHealthBar, "_on_Boss_Died")
	boss_1_2.connect("healthChanged", bossHealthBar, "_on_Boss_healthChanged")
	emit_signal("Spawning", $Stats.MaxHealth)


func _on_HurtBox_area_entered(area):
	if state != 'Spawning':
		var damage_taken = area.DAMAGE
		$Stats.Health -= damage_taken
		emit_signal('healthChanged', $Stats.Health)
		


func _on_Stats_no_health():
	emit_signal('Died')
	queue_free()


func _on_Timer_timeout():
	state = 'Started'


func _on_Corpo_body_exploded():
	min_timer -= 0.1
	max_timer -= 0.2
	probability_super_bullet += 5
	speed += 15
