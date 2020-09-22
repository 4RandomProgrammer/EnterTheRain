extends "res://Assets/Player/Character.gd"

const POWERUP1 = preload("res://Assets/PowerUps/ShotUp.tscn")
const POWERUP2 = preload("res://Assets/PowerUps/AOE Damage.tscn")

var old_fire_rate

onready var rayCast = $RayCast2D
export var DashCooldown = 10
export var DurationDash = 5

func estado_base(delta):
	movement_loop(delta)
	control_loop()
	Mouse = get_global_mouse_position()
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL

	#shoot
	if Input.is_action_pressed("Shoot") and can_fire:
		shot(false)
		can_fire = false
		$ShotCD.start(fire_rate)
	
	#PW1: atira pra cima e cai depois de um tempo
	if Input.is_action_just_pressed("PowerUp1") and onemoretimeP1 < maxtimes and raycast_pos(Mouse):
		emit_signal("PW1_used")
		var pw1 = POWERUP1.instance()
		pw1.global_position = Mouse
		pw1.damage = skill_damage_modifier * (dano + pw1.damage)
		get_parent().add_child(pw1)
		$PowerUp1CD.start(cooldownP1)
		onemoretimeP1 += 1
	
	#pw2: Cria uma area de dano por segundo?
	if Input.is_action_just_pressed("PowerUp2") and onemoretimeP2 < maxtimes and raycast_pos(Mouse):
		emit_signal("PW2_used")
		var pw2 = POWERUP2.instance()
		pw2.global_position = Mouse
		pw2.damage = skill_damage_modifier * (dano + pw2.damage)
		get_parent().add_child(pw2)
		$PowerUP2CD.start(cooldownP2)
		onemoretimeP2 += 1

#stealth
func roll_state():
	if $DashCD.is_stopped():
		$DashCD.start(DashCooldown)
		emit_signal("Dash_used")
		$DurationFireRate.start(DurationDash)
		old_fire_rate = fire_rate
		fire_rate /= 2
	else:
		state = MOVE

func raycast_pos(mouse):
	rayCast.cast_to = mouse - global_position
	rayCast.force_raycast_update()

	if !rayCast.is_colliding():
		return true
	else:
		return false

func _on_DurationFireRate_timeout():
	fire_rate = old_fire_rate
