extends "res://Assets/Enimies/Torretas/Turret_base.gd"
onready var Explosion_target = load("res://Assets/Enimies/Explosion_target.tscn")

func try_aim_player_and_shoot():
	if turret_range.entity_aimed():
		rotation = (turret_range.target.position - position).angle()
		if can_shoot:
			shoot(turret_range.target.position)
	else:  
		can_shoot = false
		$ShootTimer.start()

func shoot(_pos): 
	var explosion_target = Explosion_target.instance()
	explosion_target.position = turret_range.target.position
	get_parent().add_child(explosion_target)
	can_shoot = false  
	$ShootTimer.start()
