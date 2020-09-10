extends Node2D

signal CD_PW1(cooler1)
signal CD_PW2(cooler2)

#tipos de buffs: DoubleDamage, Spikes
onready var player = get_parent()
var spikes = 0
var TBActive = false

#Buffs Stackaveis
func apply_doubleDamage():
	player.set_MaxHealth(-player.MaxHealth/2)
	player.shot_damage_modifier *= 2
	player.skill_damage_modifier *= 2
	if player.Health > player.MaxHealth:
		player.set_NewHealth(player.MaxHealth - player.Health)

func cd_changer():
	player.cooldownP1 = player.cooldownP1 * 1.5
	player.cooldownP2 = player.cooldownP2 * 1.5
	player.skill_damage_modifier *= 1.5
	emit_signal("CD_PW1", player.cooldownP1)
	emit_signal("CD_PW2", player.cooldownP2)

#TODO
func apply_Spikes():
	$Spikes/C1.visible = true
	$Spikes/C1/Hitbox/CollisionShape2D.set_deferred("disabled",true)
	$Spikes/C1/Hitbox.DAMAGE += 0.5
	$Spikes/C2.visible = true
	$Spikes/C2/Hitbox/CollisionShape2D.set_deferred("disabled",true)
	$Spikes/C3.visible = true
	$Spikes/C3/Hitbox/CollisionShape2D.set_deferred("disabled",true)
	$Spikes.DAMAGE += 0.5
	player.MAX_SPEED -= player.MAX_SPEED * 0.1

#BuffsTemporários
#Como vou controlar os buffs temporários?
#Fazendo um geral
func temp_buff_control():
	if !TBActive:
		pass
