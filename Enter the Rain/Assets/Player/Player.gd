extends "res://Assets/Player/Character.gd"

#Me batendo com o git, scrr
const POWERUP1 = preload("res://Assets/PowerUps/Granada.tscn")
const ROLL_SPEED = 450


#Func para os estados
func estado_base(delta):
	rot_sprite()
	control_loop()
	movement_loop(delta)
	
	if Input.is_action_just_pressed("Roll"):
		emit_signal("Dash_used")
		state = ROLL
	
	#Cond. tiro
	if Input.is_action_pressed("Shoot") and can_fire:
		shot(false)
		can_fire = false
		$ShotCD.start(fire_rate)
		$AnimationPlayer.play("Shoot")
	
	#Reset da animação
	if Input.is_action_just_released("Shoot"):
		$AnimationPlayer.stop()
		$Weapon.frame = 0
	
	#Cond. Granada
	elif Input.is_action_just_pressed("PowerUp1") and onemoretimeP1 < maxtimes:
		var powerup1 = POWERUP1.instance()
		get_parent().add_child(powerup1)
		powerup1.position = $Weapon/Position2D.global_position
		powerup1.rotation_degrees = $Weapon.rotation_degrees
		powerup1.apply_impulse(Vector2(), Vector2(powerup1.BULLETSPEED, 0).rotated($Weapon.rotation))
		
		onemoretimeP1 += 1
		$PowerUp1CD.start(cooldownP1)
		emit_signal("PW1_used")
	
	#Cond. Rajada stun
	elif Input.is_action_just_pressed("PowerUp2") and onemoretimeP2 < maxtimes:
		var i = 0
		emit_signal("PW2_used")
		
		onemoretimeP2 += maxtimes
		
		can_fire = false
		Can_PowerUp2 = false
		
		while i < 5:
			shot(true)
			yield(get_tree().create_timer(0.2),"timeout")
			can_fire = false
			i += 1
		
		can_fire = true
		$PowerUP2CD.start(cooldownP2)
		

func roll_state():
	$AnimationPlayer.play("Dash")
	moveDirection = roll_vector * ROLL_SPEED
	$HurtBox/CollisionShape2D.call_deferred("set","disabled", true)
	move()

func rot_sprite():
	var rotation = int($Weapon.rotation_degrees)	
	
	rotation = rotation % 360
	
	if(rotation < 0):
		rotation += 360
	
	if( rotation >= 0 and rotation < 45 ):
		$Sprite.frame = 1
		$Weapon.flip_v = false
	elif( rotation >= 45 and rotation < 90 ):
		$Sprite.frame = 2
	elif( rotation >= 90 and rotation < 135 ):
		$Sprite.frame = 3
		$Weapon.flip_v = true
	elif( rotation >= 135 and rotation < 180 ):
		$Sprite.frame = 4
		$Weapon.flip_v = true
	elif( rotation >= 180 and rotation < 225 ):
		$Sprite.frame = 5
		$Weapon.flip_v = true
	elif( rotation >= 225 and rotation < 270 ):
		$Sprite.frame = 6
		$Weapon.flip_v = true
	elif( rotation >= 270 and rotation < 315 ):
		$Sprite.frame = 7
		$Weapon.flip_v = false
	elif(rotation >= 315 and rotation < 360 ):
		$Sprite.frame = 0
		$Weapon.flip_v = false


func _on_AnimationPlayer_animation_finished(_Dash):
	state = MOVE
	$HurtBox/CollisionShape2D.call_deferred("set","disabled", false)
