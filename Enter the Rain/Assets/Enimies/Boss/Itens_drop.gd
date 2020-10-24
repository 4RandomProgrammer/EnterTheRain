extends Node2D

onready var No_hit_item = preload('res://Assets/Itens/NoHitItem.tscn')
onready var item_damage = preload("res://Assets/Itens/Item_damage.tscn")
onready var item_atack_speed = preload("res://Assets/Itens/Item_atack_speed.tscn")
onready var item_move_speed = preload("res://Assets/Itens/Item_move_speed.tscn")
onready var item_stun_prob = preload("res://Assets/Itens/Item_stun_prob.tscn")
onready var item_extra_shots = preload("res://Assets/Itens/Item_extra_shots.tscn")
onready var item_maxhealth = preload("res://Assets/Itens/Item_maxhealth.tscn")
onready var item_missile = preload("res://Assets/Itens/Item_missile.tscn")
onready var item_life_steal = preload("res://Assets/Itens/Item_life_steal.tscn")
onready var lista_de_itens = [item_damage, item_atack_speed, item_move_speed, item_stun_prob,
							  item_extra_shots, item_maxhealth, item_missile, item_life_steal]

onready var spawn_position = get_parent().global_position
onready var Player = get_parent().get_parent().get_node('Player')
onready var player_initial_life = Player.Health

func spawn_bossReward_itens():
	lista_de_itens.shuffle()
	var item = lista_de_itens[0].instance()
	if player_initial_life != Player.Health:  
		# Vida do player mudou durante batalha (não foi NoHit)
		item.global_position = spawn_position
	else:  
		# Vida do player não mudou durante batalha (NoHit). Dropar item especial também...
		item.global_position = spawn_position - Vector2(0, 32)
		var special_item = No_hit_item.instance()
		special_item.global_position = spawn_position + Vector2(0, 32)
		get_parent().get_parent().call_deferred('add_child', special_item)
		
	get_parent().get_parent().call_deferred('add_child', item)


func _on_Boss_Died():
	spawn_bossReward_itens()

