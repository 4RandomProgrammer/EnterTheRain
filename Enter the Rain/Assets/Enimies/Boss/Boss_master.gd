extends KinematicBody2D

onready var boss_range = $Range
signal healthChanged(health)
signal Spawning(maxHealth, boss_name)
signal Died


func _ready():
	pass

func connect_signals(bossHealthBar, boss_name):
	connect("Spawning", bossHealthBar, "_on_Boss_Spawning")
	connect("Died", bossHealthBar, "_on_Boss_Died")
	connect("healthChanged", bossHealthBar, "_on_Boss_healthChanged")
	emit_signal("Spawning", $Stats.MaxHealth, boss_name)


func _on_Stats_no_health():
	emit_signal('Died')
	queue_free()

