extends "res://Assets/Player/Character.gd"

const POWERUP1 = preload("res://Assets/PowerUps/ShotUp.tscn")
const POWERUP2 = 0

func estado_base(delta):
	movement_loop(delta)
	control_loop()
	var Mouse = get_global_mouse_position()
	
	#shoot
	if Input.is_action_just_pressed("Shoot"):
		shot(false)
		can_fire = false
		$ShotCD.start(fire_rate)
	
	#PW1: atira pra cima e cai depois de um tempo
	if Input.is_action_just_pressed("PowerUp1") and Can_PowerUp1:
		emit_signal("PW1_used")
		var pw1 = POWERUP1.instance()
		pw1.global_position = Mouse
		get_parent().add_child(pw1)
		$PowerUp1CD.start(cooldownP1)
		Can_PowerUp1 = false
	
	#pw2: Cria uma area de dano por segundo?
	if Input.is_action_just_pressed("PowerUp2") and Can_PowerUp1:
		emit_signal("PW2_used")
		pass

#da tp pra uma posição
func roll_state():
	pass

