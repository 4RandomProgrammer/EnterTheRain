extends "res://Assets/Spawners/RandomSpawner.gd"

onready var Chest = preload("res://Assets/Bau/Bau.tscn")
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
onready var tamanho_lista = len(lista_de_itens)


func _ready():
	rng.randomize()
	var chests_quant = rng.randi_range(min_entities, max_entities)
	while chests_quant != 0:
		var entity = create_entity_in_range(Chest)  # Função que cria uma entidade com uma localização aleatória dentro da área.
		if entity:
			entity.item = lista_de_itens[rng.randi_range(0, tamanho_lista - 1)]  # Escolher um item aleatório para o baú.
			get_parent().call_deferred("add_child",entity)
			chests_quant -= 1
