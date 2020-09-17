extends KinematicBody2D

var damage = 1
onready var stats = $Stats_range
enum {
	SPAWNING,
	NORMAL,
	KNOCKED
}
var state = SPAWNING

signal Spawning
signal healthChanged
signal Died


func _ready():
	# Conectando os sinais:
	var bossHealthBar2 = get_parent().get_parent().get_node('Player').get_node('Camera2D').get_node('CanvasLayer').get_node('HealthBarBoss2')
	connect("Spawning", bossHealthBar2, "_on_Boss_Spawning")
	connect("healthChanged", bossHealthBar2, "_on_Boss_healthChanged")
	emit_signal("Spawning", stats.MaxHealth)


func _on_HurtBox_area_entered(area):
	if state != SPAWNING and state != KNOCKED:
		var damage_taken = area.DAMAGE
		stats.Health -= damage_taken
		emit_signal('healthChanged', stats.Health)

func _on_Timer_spawn_timeout():
	state = NORMAL

func _on_Stats_range_no_health():
	state = KNOCKED
	$Sprite.self_modulate.r = 0.2

func revive():
	$Sprite.self_modulate.r = 1.0
	stats.Health = 15
	emit_signal('healthChanged', stats.Health)
	state = NORMAL
