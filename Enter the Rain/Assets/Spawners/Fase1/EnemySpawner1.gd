extends "res://Assets/Spawners/RandomSpawner.gd"

onready var Torreta = load("res://Assets/Enimies/Torretas/Bullets_turret.tscn")
onready var Inimigo = load("res://Assets/Enimies/Perseguidores/Bee_enemy.tscn")
onready var enimies_list = [Torreta, Inimigo]

func _ready():
	spawn_entities(enimies_list)
