extends "res://Assets/Enimies/Torretas/Turret_base.gd"

export var shoottimer = 0.5
var Explosion_target = load("res://Assets/Enimies/Explosion_target.tscn")
var veneno = load("res://Assets/Enimies/Poison.tscn")
var choice = true



func try_aim_player_and_shoot():
	if turret_range.entity_aimed():
		rotation = (turret_range.target.position - position).angle()
		if can_shoot:
			shoot(turret_range.target.position)
	else:  
		can_shoot = false
		$ShootTimer.start(shoottimer)

func shoot(pos): 
	if choice:
		var explosion_target = Explosion_target.instance()
		explosion_target.position = turret_range.target.position
		get_parent().add_child(explosion_target)
		can_shoot = false  
		$ShootTimer.start(shoottimer)
		choice = false
	else:
		var poison = veneno.instance()
		poison.position = turret_range.target.position
		get_parent().add_child(poison)
		can_shoot = false  
		$ShootTimer.start(shoottimer)
		choice = true
