extends "res://Assets/Spawners/RandomSpawner.gd"

onready var buff_altar = load("res://Assets/Altares/Buff Shrine.tscn")
onready var life_altar = load("res://Assets/Altares/Life Altar.tscn")
onready var altar_list = [buff_altar, life_altar]

func _ready():
	spawn_entities(altar_list)
