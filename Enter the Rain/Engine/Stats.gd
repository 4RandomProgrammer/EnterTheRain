extends Node

export(int) var  MaxHealth = 1
onready var Health setget set_health

signal no_health
signal player_health(health)

func _ready():
	Health = MaxHealth
	emit_signal("player_health",MaxHealth)

func set_health(value):
	Health = value
	if Health <= 0:
		emit_signal("no_health")

func maxhealth_changed(value):
	MaxHealth = value
	emit_signal("player_health",MaxHealth)

