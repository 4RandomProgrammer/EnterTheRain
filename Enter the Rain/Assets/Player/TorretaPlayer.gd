extends KinematicBody2D

const Bullet = preload("res://Assets/Shot/Shot.tscn")
onready var turret_range = $Range
onready var stats = $Stats
var can_shoot = true

func _physics_process(delta):
	update()
	try_aim_player_and_shoot()

func try_aim_player_and_shoot():
	if turret_range.player_aimed():
		rotation = (turret_range.target.position - position).angle()
		if can_shoot:
			shoot(turret_range.target.position)
func shoot(pos):
	pass
