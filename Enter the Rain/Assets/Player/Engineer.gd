extends "res://Assets/Player/Character.gd"


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
	elif Input.is_action_just_pressed("PowerUp2"):
		pass

#Dash que aumenta a speed :0
func roll_state():
	pass
