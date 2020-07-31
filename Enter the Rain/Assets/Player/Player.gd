extends "res://Assets/Player/Character.gd"

#Me batendo com o git, scrr
const POWERUP1 = preload("res://Assets/PowerUps/Granada.tscn")
const ROLL_SPEED = 450


func _physics_process(delta):
	#Maquina de estados
	match state:
		MOVE:
			estado_base(delta)

		ROLL:
			roll_state()

#Func para os estados
func estado_base(delta):
	control_loop()
	movement_loop(delta)
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	
	#Cond. tiro
	if Input.is_action_pressed("Shoot") and can_fire:
		shot(false)
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
	
	#Cond. Granada
	elif Input.is_action_just_pressed("PowerUp1") and Can_PowerUp1:
		emit_signal("PW1_used")
		var powerup1 = POWERUP1.instance()
		get_parent().add_child(powerup1)
		powerup1.position = $Weapon/Position2D.global_position
		powerup1.rotation_degrees = $Weapon.rotation_degrees
		powerup1.apply_impulse(Vector2(), Vector2(powerup1.BULLETSPEED, 0).rotated($Weapon.rotation))
		Can_PowerUp1 = false
		yield(get_tree().create_timer(cooldownP1), "timeout")
		Can_PowerUp1 = true
	
	#Cond. Rajada stun
	elif Input.is_action_just_pressed("PowerUp2") and Can_PowerUp2:
		emit_signal("PW2_used")
		var i = 0
		can_fire = false
		Can_PowerUp2 = false
		while i < 5:
			shot(true)
			yield(get_tree().create_timer(0.2),"timeout")
			i += 1
		
		can_fire = true
		
		yield(get_tree().create_timer(cooldownP2),"timeout")
		Can_PowerUp2 = true

func roll_state():
	$AnimationPlayer.play("Dash")
	moveDirection = roll_vector * ROLL_SPEED
	$HurtBox/CollisionShape2D.call_deferred("set","disabled", true)
	move()


func _on_AnimationPlayer_animation_finished(_Dash):
	state = MOVE
	$HurtBox/CollisionShape2D.call_deferred("set","disabled", false)
