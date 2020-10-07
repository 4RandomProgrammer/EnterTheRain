extends Node2D

onready var TurretExplosivo_life = $TurretExplosivo.Stats.MaxHealth
onready var TurretVeneno_life = $TurretVeneno.Stats.MaxHealth
onready var TurretTeia_life = $TurretTeia.Stats.MaxHealth
onready var Cientista = $Cientista

signal healthChanged(health)
signal Spawning(maxHealth)
signal Died

func _ready():
	var bossHealthBar = get_parent().get_node('Player').get_node('Camera2D').get_node('CanvasLayer').get_node('HealthBarBoss')
	connect("Spawning", bossHealthBar, "_on_Boss_Spawning")
	connect("Died", bossHealthBar, "_on_Boss_Died")
	connect("healthChanged", bossHealthBar, "_on_Boss_healthChanged")
	emit_signal("Spawning", TurretExplosivo_life + TurretTeia_life + TurretVeneno_life)


func _on_TurretVeneno_Turret_damaged(health):
	TurretVeneno_life = health
	update_turret_HealthBar()

func _on_TurretTeia_Turret_damaged(health):
	TurretTeia_life = health
	update_turret_HealthBar()

func _on_TurretExplosivo_Turret_damaged(health):
	TurretExplosivo_life = health
	update_turret_HealthBar()


func update_turret_HealthBar():
	if TurretExplosivo_life + TurretTeia_life + TurretVeneno_life == 0:
		# Todas as torres morreram.
		Cientista.protected = false
		emit_signal("Spawning", Cientista.Stats.MaxHealth)
	else:
		emit_signal("healthChanged", TurretExplosivo_life + TurretTeia_life + TurretVeneno_life)


func _on_Cientista_Cientista_damaged(health):
	emit_signal("healthChanged", health)

func _on_Stats_no_health():
	emit_signal("Died")
	queue_free()
