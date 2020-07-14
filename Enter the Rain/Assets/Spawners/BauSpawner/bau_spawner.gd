extends "res://Assets/Spawners/RandomSpawner.gd"

onready var Chest = preload("res://Assets/Bau/Bau.tscn")
onready var Sword1 = preload("res://Assets/Itens/Sword1.tscn")
onready var Bow1 = preload("res://Assets/Itens/Bow1.tscn")
onready var Diamond = preload("res://Assets/Itens/Diamond.tscn")
onready var Staff = preload("res://Assets/Itens/Staff.tscn")

onready var lista_de_itens = [Sword1, Bow1, Diamond, Staff]
onready var tamanho_lista = len(lista_de_itens)


func _ready():
	rng.randomize()
	var chests_quant = rng.randi_range(min_entities, max_entities)
	for _i in range(chests_quant):
		create_entity_in_range(Chest)  # Função que cria uma entidade com uma localização aleatória dentro da área.
		entity.item = lista_de_itens[rng.randi_range(0, tamanho_lista - 1)]  # Escolher um item aleatório para o baú.
		get_parent().call_deferred("add_child",entity)
