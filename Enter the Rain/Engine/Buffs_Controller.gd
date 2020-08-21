extends Node

#tipos de buffs: DoubleDamage, Spikes
onready var player = get_parent()
var spikes = 0

func apply_doubleDamage():
	player.set_MaxHealth(-player.MaxHealth/2)
	player.damage_modifier *= 2
	if player.Health > player.MaxHealth:
		player.set_NewHealth(player.MaxHealth - player.Health)

func apply_Spikes():
	$Spikes/CollisionShape2D.set_deferred("disabled",false)
	spikes += 0.5
	player.MAX_SPEED -= player.MAX_SPEED * 0.1
