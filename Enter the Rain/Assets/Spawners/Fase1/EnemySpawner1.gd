extends "res://Assets/Spawners/RandomSpawner.gd"

onready var Torreta = preload("res://Assets/Enimies/Torretas/Bullets_turret.tscn")
onready var Inimigo = preload("res://Assets/Enimies/Perseguidores/Bee_enemy.tscn")
onready var Besouro = preload('res://Assets/Enimies/InimigosNProntos/melee_attacker.tscn')
onready var Super_bee = preload('res://Assets/Enimies/Perseguidores/Super_bee.tscn')
onready var Rusher_shooter = preload('res://Assets/Enimies/Perseguidores/Rusher_Shooter.tscn')
onready var Enemy_shooter = preload("res://Assets/Enimies/InimigosNProntos/Enemy_shooter.tscn")
onready var ShootNAtack = preload("res://Assets/Enimies/InimigosNProntos/ShootNAttack.tscn")
onready var enimies_list = [Torreta, Inimigo, Besouro, Super_bee, Rusher_shooter, Enemy_shooter, ShootNAtack]

func _ready():
	spawn_entities(enimies_list)
