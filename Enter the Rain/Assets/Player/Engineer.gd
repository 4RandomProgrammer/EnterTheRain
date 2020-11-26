extends "res://Assets/Player/Character.gd"

var turret_counter = 0
var old_maxspeed
var turret_ref1
var turret_ref2
var dx
var dy
var rangeSkills
onready var rayCast = $RayCast2D
export var DashCooldown = 10
export var DashDuration = 5

const POWERUP2 = preload("res://Assets/PowerUps/Mina.tscn")
const POWERUP1 = preload("res://Assets/PowerUps/TorretaPlayer.tscn")
const DASH = preload("res://Assets/PowerUps/Shield.tscn")
const MAXTURRETS = 2

func estado_base(delta):
	Mouse = get_global_mouse_position()
	rot_sprite()
	movement_loop(delta)
	control_loop()
	range_control()
	dx = Mouse.x - global_position.x
	dy = Mouse.y - global_position.y
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	
	if Input.is_action_pressed("Shoot") and can_fire:
		shot(false)
		can_fire = false
		$ShotCD.start(fire_rate)
		$AnimationPlayer.play("Shoot")
		
	if Input.is_action_just_released("Shoot"):
		$AnimationPlayer.stop()
		$Weapon.frame = 0
	
	#Tworretas
	elif Input.is_action_just_released("PowerUp1") and onemoretimeP1 < MAXTURRETS and sqrt(dx * dx + dy * dy) >= 40 and sqrt(dx * dx + dy * dy) <= 240:
		var pw1 = POWERUP1.instance()
	
		if turret_counter < 2:
			turret_counter += 1
			if turret_counter == 1:
				turret_ref1 = pw1
			elif turret_counter == 2:
				turret_ref2 = pw1
		else:
			turret_ref1.queue_free()
			turret_ref1 = turret_ref2
			turret_ref2 = pw1
		
		pw1.global_position = ray_pos(Mouse)
		
		emit_signal("PW1_used")
		$PowerUp1CD.start(cooldownP1)
		onemoretimeP1 += 1
		get_parent().add_child(pw1)
		$Range.visible = false
		
	
	#Mina, teus cabelo é daora, teu corpão violão....
	elif Input.is_action_just_released("PowerUp2") and onemoretimeP2 < maxtimes and sqrt(dx * dx + dy * dy) >= 40 and sqrt(dx * dx + dy * dy) <= 240:
		var pw2 = POWERUP2.instance()
		
		pw2.global_position = ray_pos(Mouse)
		pw2.damage = skill_damage_modifier * (dano + pw2.damage)
		$PowerUP2CD.start(cooldownP2)
		$Range.visible = false
		emit_signal("PW2_used")
		onemoretimeP2 += 1
		get_parent().add_child(pw2)

#Dash que aumenta a speed :)
func roll_state():
	if $DashCD.is_stopped():
		$Shield.visible = true
		$HurtBox/CollisionShape2D.call_deferred("set","disabled",true)
		$Shield/DurationShield.start(DashDuration)
		$DashCD.start(DashCooldown)
		emit_signal("Dash_used")
	else:
		state = MOVE
	
	
func turret_dead():
	turret_counter -= 1

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


func _on_DurationShield_timeout():
	$HurtBox/CollisionShape2D.call_deferred("set","disabled",false)
	$Shield.visible = false

func range_control():
	if Input.is_action_just_pressed("PowerUp1") and Can_PowerUp1:
		$Range.visible = true
	elif Input.is_action_just_pressed("PowerUp2") and Can_PowerUp2:
		$Range.visible = true
		
func ray_pos(mouse):
	rayCast.cast_to = Mouse - global_position
	rayCast.force_raycast_update()

	if !rayCast.is_colliding():
		return mouse
	else:
		var turret_radius = $HurtBox/CollisionShape2D.get_shape().radius
		return rayCast.get_collision_point() + rayCast.get_collision_normal() * turret_radius
