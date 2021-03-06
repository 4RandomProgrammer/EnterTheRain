extends "res://Assets/Player/Character.gd"

const ROLL_SPEED = 450
const EXPLOSIVE_BULLET = preload("res://Assets/Enimies/Enemy_bullet/ExplosiveBulletPlayer.tscn")
const POWERUP2 = preload("res://Assets/PowerUps/Fly.tscn")

export var DurationPW1 = 5
export var CoolDown_Dash = 5

var damage = 1
var Can_Roll = true
var charge = 0
var area_transform
var dx
var dy
var direction = 0


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
		direction = Mouse - global_position
		state = ROLL
		$DashCD.start(CoolDown_Dash)
		emit_signal("Dash_used")
		$AnimationPlayer.play("DashB")
	
	#tiro normal
	if Input.is_action_pressed("Shoot") and can_fire:
		shot(false)
		can_fire = false
		$ShotCD.start(fire_rate)
		$AnimationPlayer.play("Shoot")
		
	if Input.is_action_just_released("Shoot"):
		$AnimationPlayer.stop()
		$Weapon.frame = 0
	
	#tiros explosivos
	elif Input.is_action_pressed("PowerUp1") and onemoretimeP1 < maxtimes:
		onemoretimeP1 += 1
		$DurationPw1.start(DurationPW1)
		emit_signal("PW1_used")
		$PowerUp1CD.start(cooldownP1)
		state = PW1
	
	#Charge, explosão que joga longe
	elif Input.is_action_pressed("PowerUp2") and onemoretimeP2 < maxtimes:
		state = PW2
		$Range.visible = true


#Salto que na queda faz queda dar dano em área
func roll_state():
	moveDirection = direction.normalized() * ROLL_SPEED
	move()
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)

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
	dx = Mouse.x - global_position.x
	dy = Mouse.y - global_position.y
	
	charge += 1
	if $BarraTeste.frame != 99:
		$BarraTeste.frame += 1
	charge = clamp(charge,0,100)
	
	
	if Input.is_action_just_pressed("PowerUp2") and sqrt(dx * dx + dy * dy) <= 200:
		$PowerUP2CD.start(cooldownP2)
		emit_signal("PW2_used")
		onemoretimeP2 += 1
		$Range.visible = false
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
		$Knockback_Duration.start(0.6)
	

func _on_DurationPw1_timeout():
	state = MOVE


func _on_AnimationPlayer_animation_finished(_DashB):
	state = MOVE
	$HurtBox/CollisionShape2D.set_deferred("disabled", false)


func _on_DashCD_timeout():
	Can_Roll = true


func _on_Knockback_Duration_timeout():
	state = MOVE


func _on_Hitbox_body_entered(body):
	if body.has_method("stun_state"):
		body.stun_state()
