extends "res://Assets/Player/Character.gd"

const ROLL_SPEED = 450
const EXPLOSIVE_BULLET = preload("res://Assets/Enimies/Enemy_bullet/Explosive_bullet.tscn")
const POWERUP2 = preload("res://Assets/PowerUps/Fly.tscn")

export var DurationPW1 = 5
export var CoolDown_Dash = 5

var damage = 1
var Can_Roll = true
var charge = 0
var area_transform


func _physics_process(delta):
	match state:
		PW1:
			state_powerup1(delta)
		PW2:
			state_powerup2(delta)
		KNOCKBACK:
			knockback_state()

func estado_base(delta):
	control_loop()
	movement_loop(delta)
	Mouse = get_global_mouse_position()
	
	if Input.is_action_just_pressed("Roll") and Can_Roll:
		state = ROLL
		$DashCD.start(CoolDown_Dash)
	
	#tiro normal
	if Input.is_action_pressed("Shoot") and can_fire:
		shot(false)
		can_fire = false
		$ShotCD.start(fire_rate)
	
	#tiros explosivos
	elif Input.is_action_pressed("PowerUp1") and Can_PowerUp1:
		Can_PowerUp1 = false
		$DurationPw1.start(DurationPW1)
		emit_signal("PW1_used")
		$PowerUp1CD.start(cooldownP1)
		state = PW1
	
	#Charge, explosão que joga longe
	elif Input.is_action_pressed("PowerUp2") and Can_PowerUp2:
		state = PW2
		 

#Salto que na queda faz queda dar dano em área
func roll_state():
	moveDirection = (Mouse - global_position).normalized() * ROLL_SPEED
	move()
	$DashCD.start()
	$AnimationPlayer.play("DashB")

func state_powerup1(delta):
	control_loop()
	movement_loop(delta)
	if Input.is_action_pressed("Shoot") and can_fire:
		var pw1 = EXPLOSIVE_BULLET.instance()
		pw1.start($Weapon/Position2D.global_position, $Weapon.rotation)
		get_parent().add_child(pw1)
		can_fire = false
		$ShotCD.start(can_fire)

func state_powerup2(delta):
	movement_loop(delta)
	control_loop()
	var pw2 = POWERUP2.instance()
	Mouse = get_global_mouse_position()
	
	charge += 1
	if $BarraTeste.frame != 99:
		$BarraTeste.frame += 1
	charge = clamp(charge,0,100)
	
	
	if Input.is_action_just_released("PowerUp2"):
		if charge >= 0 and charge < 50:
			pw2.global_position = Mouse
			get_parent().add_child(pw2)
		elif charge >= 50 and charge < 100:
			pw2.damage += 1
			pw2.global_position = Mouse
			get_parent().add_child(pw2)
		elif charge == 100:
			pw2.damage += 2
			pw2.global_position = Mouse
			get_parent().add_child(pw2)
		
		$BarraTeste.frame = 0
		charge = 0
		
		state = MOVE

func knockback_state():
	moveDirection = (global_transform.origin - area_transform).normalized() * 600
	move()

func to_knockback(area_pos):
	state = KNOCKBACK
	area_transform = area_pos
	if $Knockback_Duration.is_stopped():
		$Knockback_Duration.start()
	

func _on_DurationPw1_timeout():
	state = MOVE


func _on_AnimationPlayer_animation_finished(DashB):
	$Hitbox/CollisionShape2D.call_deferred("set","disabled",false)
	yield(get_tree().create_timer(0.2),"timeout")
	state = MOVE
	$Hitbox/CollisionShape2D.call_deferred("set","disabled",true)


func _on_DashCD_timeout():
	Can_Roll = true


func _on_Knockback_Duration_timeout():
	state = MOVE
