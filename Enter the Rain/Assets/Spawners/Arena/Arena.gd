extends "res://Assets/Spawners/RandomSpawner.gd"

onready var Torreta = load("res://Assets/Enimies/Torretas/Bullets_turret.tscn")
onready var Inimigo = load("res://Assets/Enimies/Perseguidores/Bee_enemy.tscn")
onready var enimies_list = [Torreta, Inimigo]

func _ready():
	rng.randomize()
	var enimies_quant = rng.randi_range(min_entities, max_entities)  # Escolher quantidade aleatoria no range de inimigos para spawnar
	while enimies_quant != 0:
		var enemy_type = rng.randi_range(0, 1)  # Escolher um dos 2 inimigos para spawnar.
		var entity = create_entity_in_range(enimies_list[enemy_type])
		if entity:
			get_parent().call_deferred("add_child", entity)
			enimies_quant -= 1
