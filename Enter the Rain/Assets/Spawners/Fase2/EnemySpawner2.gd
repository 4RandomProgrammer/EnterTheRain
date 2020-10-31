extends 'res://Assets/Spawners/RandomSpawner.gd'

onready var Snail = preload('res://Assets/Enimies/Perseguidores/Snail.tscn')
onready var EnemyVeneno = preload('res://Assets/Enimies/InimigosNProntos/Enemy_veneno.tscn')
onready var Creeper = preload('res://Assets/Enimies/Perseguidores/Explosive_enemy.tscn')
onready var SpinShooter = preload('res://Assets/Enimies/Perseguidores/SpinShooter.tscn')
onready var ShooterReverse = preload('res://Assets/Enimies/InimigosNProntos/Enemy_shooter_reverse.tscn')
onready var TPNAtack = preload('res://Assets/Enimies/InimigosNProntos/TP_and_Attack.tscn')
onready var Scorpion = preload('res://Assets/Enimies/Torretas/PoisonAndExplosion.tscn')
onready var enimies_list = [Snail, EnemyVeneno, Creeper, SpinShooter, ShooterReverse, TPNAtack, Scorpion]

func _ready():
	spawn_entities(enimies_list)
