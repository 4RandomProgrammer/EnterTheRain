extends Node2D

onready var Boss_melee = $Boss_melee
onready var Boss_range = $Boss_range
var boss_melee_knocked = false
var boss_range_knocked = false

signal Died

func _ready():
	# Conectando os sinais de "morte" à barra de vida.
	var health_bar_1 = get_parent().get_node('Player').get_node('Camera2D').get_node('CanvasLayer').get_node('HealthBarBoss')
	var health_bar_2 = get_parent().get_node('Player').get_node('Camera2D').get_node('CanvasLayer').get_node('HealthBarBoss2')
	connect('Died', health_bar_1, '_on_Boss_Died')
	connect('Died', health_bar_2, '_on_Boss_Died')


func _on_Stats_range_no_health():  # O boss range acabou de ser "nocauteado"
	if boss_melee_knocked:
		emit_signal('Died')
		queue_free()
	else:
		boss_range_knocked = true
		$Timer_revive.start()


func _on_Stats_melee_no_health():  # O boss melee acabou de ser "nocauteado"
	if boss_range_knocked:
		emit_signal('Died')
		queue_free()
	else:
		boss_melee_knocked = true
		$Timer_revive.start()


func _on_Timer_revive_timeout():  # O player nao matou o outro boss a tempo.
	if boss_melee_knocked:
		boss_melee_knocked = false
		Boss_melee.revive()
	else:
		boss_range_knocked = false
		Boss_range.revive()
