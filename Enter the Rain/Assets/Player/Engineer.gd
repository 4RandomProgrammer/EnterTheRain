extends "res://Assets/Player/Character.gd"

var turret_counter = 0
var old_maxspeed
var turret_ref1
var turret_ref2
var dx
var dy
const POWERUP2 = preload("res://Assets/PowerUps/Mina.tscn")
const POWERUP1 = preload("res://Assets/PowerUps/TorretaPlayer.tscn")
const DASH = preload("res://Assets/PowerUps/Shield.tscn")

func estado_base(delta):
	var Mouse = get_global_mouse_position()
	movement_loop(delta)
	control_loop()
	dx = Mouse.x - global_position.x
	dy = Mouse.y - global_position.y
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	
	if Input.is_action_pressed("Shoot") and can_fire:
		shot(false)
		can_fire = false
		$ShotCD.start(fire_rate)
	
	#Tworretas
	elif Input.is_action_just_pressed("PowerUp1") and Can_PowerUp1 and sqrt(dx * dx + dy * dy) <= 200:
		var pw1 = POWERUP1.instance()
		emit_signal("PW1_used")
		if turret_counter < 2:
			turret_counter += 1
			get_parent().add_child(pw1)
			pw1.global_position = Mouse
			$PowerUp1CD.start(cooldownP1)
			Can_PowerUp1 = false
			
			if turret_counter == 1:
				turret_ref1 = pw1
			elif turret_counter == 2:
				turret_ref2 = pw1
		else:
			turret_ref1.queue_free()
			turret_ref1 = turret_ref2
			turret_ref2 = pw1
			get_parent().add_child(pw1)
			pw1.global_position = Mouse
			$PowerUp1CD.start(cooldownP1)
			Can_PowerUp1 = false
			
	
	#Mina, teus cabelo é daora, teu corpão violão....
	elif Input.is_action_just_pressed("PowerUp2") and Can_PowerUp2 and sqrt(dx * dx + dy * dy) <= 200:
		emit_signal("PW2_used")
		Can_PowerUp2 = false
		var pw2 = POWERUP2.instance()
		get_parent().add_child(pw2)
		pw2.global_position = Mouse
		$PowerUP2CD.start(cooldownP2)
			

#Dash que aumenta a speed :)
func roll_state():
	if $DashCD.is_stopped():
		$Shield/CollisionShape2D.call_deferred("set","disabled",false)
		$HurtBox/CollisionShape2D.call_deferred("set","disabled",true)
		$Shield/Sprite.call_deferred("set","visible",true)
		$Shield/DurationShield.start(5)
		$DashCD.start(10)
	else:
		state = MOVE
	
	
func turret_dead():
	turret_counter -= 1

func _on_DurationShield_timeout():
	$Shield/CollisionShape2D.call_deferred("set","disabled",true)
	$HurtBox/CollisionShape2D.call_deferred("set","disabled",false)
	$Shield/Sprite.call_deferred("set","visible",false)



