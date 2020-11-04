extends 'res://Assets/Spawners/RandomSpawner.gd'

onready var SpinningMelee = preload('res://Assets/Enimies/InimigosNProntos/Enemy_Spinning_Melee.tscn')
onready var StealthNTP = preload('res://Assets/Enimies/InimigosNProntos/StealthAndTP.tscn')
onready var StealthFirst = preload('res://Assets/Enimies/InimigosNProntos/Stealth_First.tscn')
onready var MeleeRusher = preload('res://Assets/Enimies/InimigosNProntos/Meelee_Rusher.tscn')
onready var Mortar = preload('res://Assets/Enimies/Torretas/Mortar.tscn')
onready var enimies_list = [SpinningMelee, StealthNTP, StealthFirst, MeleeRusher, Mortar]

func _ready():
	spawn_entities(enimies_list)
