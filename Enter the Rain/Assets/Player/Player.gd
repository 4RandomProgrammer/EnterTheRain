extends "res://Assets/Player/Character.gd"

#Constantes
const POWERUP1 = preload("res://Assets/PowerUps/Granada.tscn")
const ROLL_SPEED = 450

#Func para os estados
func estado_base(delta):
	print(cooldownP1)
	control_loop()
	movement_loop(delta)
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("PowerUp2") and Can_PowerUp2:
		var i = 0
		can_fire = false
		Can_PowerUp2 = false
		while i < 5:
			shot(true)
			yield(get_tree().create_timer(0.2),"timeout")
			i += 1
		
		can_fire = true
		$PowerUp2CD.start(cooldownP2)
	
	#Cond. tiro
	elif Input.is_action_pressed("Shoot") and can_fire:
		can_fire = false
		shot(false)
		$ShotCD.start(fire_rate)
	
	#Cond. Granada
	elif Input.is_action_just_pressed("PowerUp1") and Can_PowerUp1:
		Can_PowerUp1 = false
		var powerup1 = POWERUP1.instance()
		get_parent().add_child(powerup1)
		powerup1.position = $Weapon/Position2D.global_position
		powerup1.rotation_degrees = $Weapon.rotation_degrees
		powerup1.apply_impulse(Vector2(), Vector2(powerup1.BULLETSPEED, 0).rotated($Weapon.rotation))
		$PowerUp1CD.start(cooldownP1)

func roll_state():
	$AnimationPlayer.play("Dash")
	moveDirection = roll_vector * ROLL_SPEED
	$HurtBox/CollisionShape2D.call_deferred("set","disabled", true)
	move()
#Fim das funções de estado

func _on_AnimationPlayer_animation_finished(_Dash):
	state = MOVE
	$HurtBox/CollisionShape2D.call_deferred("set","disabled", false)
	
