extends "res://Assets/Player/Character.gd"

var turret_counter = 0
const POWERUP1 = preload("res://Assets/PowerUps/Mina.tscn")

func estado_base(delta):
	movement_loop(delta)
	control_loop()
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	
	if Input.is_action_pressed("Shoot") and can_fire:
		shot(false)
		can_fire = false
		$ShotCD.start(fire_rate)
	
	#Tworretas
	elif Input.is_action_just_pressed("PowerUp1"):
		pass
	
	#Mina, teus cabelo é daora, teu corpão violão....
	elif Input.is_action_just_pressed("PowerUp2") and Can_PowerUp2:
		Can_PowerUp2 = false
		var Mouse = get_global_mouse_position()
		var pw1 = POWERUP1.instance()
		get_parent().add_child(pw1)
		pw1.global_position = Mouse
		$PowerUP2CD.start(cooldownP2)
			

#Dash que aumenta a speed :)
func roll_state():
	pass
	
