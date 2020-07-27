extends "res://Assets/Player/Character.gd"

var turret_counter = 0
var turrets_spawned = 0
var turret_ref1
var turret_ref2
const POWERUP2 = preload("res://Assets/PowerUps/Mina.tscn")
const POWERUP1 = preload("res://Assets/PowerUps/TorretaPlayer.tscn")

func estado_base(delta):
	print(turret_counter)
	movement_loop(delta)
	control_loop()
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	
	if Input.is_action_pressed("Shoot") and can_fire:
		shot(false)
		can_fire = false
		$ShotCD.start(fire_rate)
	
	#Tworretas
	elif Input.is_action_just_pressed("PowerUp1") and Can_PowerUp1:
		if turret_counter < 2:
			var Mouse = get_global_mouse_position()
			var pw1 = POWERUP1.instance()
			var turret_ref1 = pw1
			get_parent().add_child(pw1)
			pw1.global_position = Mouse
			$PowerUp1CD.start(cooldownP2)
	
	#Mina, teus cabelo é daora, teu corpão violão....
	elif Input.is_action_just_pressed("PowerUp2") and Can_PowerUp2:
		Can_PowerUp2 = false
		var Mouse = get_global_mouse_position()
		var pw2 = POWERUP2.instance()
		get_parent().add_child(pw2)
		pw2.global_position = Mouse
		$PowerUP2CD.start(cooldownP2)
			

#Dash que aumenta a speed :)
func roll_state():
	pass
	
func turret_spawned():
	turret_counter += 1
	turrets_spawned += 1


func turret_dead():
	turrets_spawned -= 1
	turret_counter -= 1
