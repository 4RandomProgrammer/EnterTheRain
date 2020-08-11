extends "res://Assets/Player/Character.gd"

const ROLL_SPEED = 400
var damage = 1

func estado_base(delta):
	control_loop()
	movement_loop(delta)
	Mouse = get_global_mouse_position()
	print(Mouse.normalized())
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	
	#tiro normal
	if Input.is_action_pressed("Shoot") and can_fire:
		shot(false)
		can_fire = false
		$ShotCD.start(fire_rate)
	
	#tiros explosivos
	elif Input.is_action_pressed("PowerUp1") and Can_PowerUp1:
		pass
	
	#Charge, explosão que joga longe
	elif Input.is_action_pressed("PowerUp2") and Can_PowerUp2:
		pass
		 

#Salto que na queda faz queda dar dano em área
func roll_state():
	if $DashCD.is_stopped():
		moveDirection = Mouse.normalized() * ROLL_SPEED
		$Hitbox/CollisionShape2D.call_deferred("set","disabled",false)
		move()
		$DashCD.start()
	else:
		state = MOVE
