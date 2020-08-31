extends StaticBody2D

onready var rng = RandomNumberGenerator.new()
var player
var min_money
var used = true

func _ready():
	rng.randomize()
	min_money = rng.randi_range(100,200)


func _process(delta):
	if player and used:
		pass

func _on_Area2D_body_entered(body):
	player = body


func _on_Area2D_body_exited(body):
	player = null
