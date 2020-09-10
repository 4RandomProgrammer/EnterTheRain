extends StaticBody2D

onready var rng = RandomNumberGenerator.new()
var player
var min_money
var used = true

func _ready():
	rng.randomize()
	min_money = 0
	$Label.text = str(min_money)

func _process(delta):
	if player and used:
		if Input.is_action_just_pressed("ui_select") and player.money >= min_money:
			player.apply_buff(1)
			used = false
			$Label.visible = false

func _on_Area2D_body_entered(body):
	player = body

func _on_Area2D_body_exited(body):
	player = null
