extends "res://Assets/RandomSpawner.gd"

onready var Torreta = load("res://Assets/Torreta/Torreta.tscn")
onready var Inimigo = load("res://Assets/Inimigo/Inimigo.tscn")
onready var enimies_list = [Torreta, Inimigo]

func _ready():
	rng.randomize()
	var enimies_quant = rng.randi_range(min_entities, max_entities)  # Escolher quantidade aleatoria no range de inimigos para spawnar
	for _i in range(enimies_quant):
		var enemy_type = rng.randi_range(0, 1)  # Escolher um dos 2 inimigos para spawnar.
		create_entity_in_range(enimies_list[enemy_type])
		get_parent().call_deferred("add_child", entity)
