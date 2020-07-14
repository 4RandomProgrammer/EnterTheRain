extends KinematicBody2D

#Me batendo com o git, scrr

enum {
	MOVE,
	ROLL
}

#Variaveis
onready var InvunerabilityTimer = $InvunerabilityTimer
onready var hurtbox = $HurtBox
onready var Health = MaxHealth
export(int) var  MaxHealth = 1
export (int) var MAX_SPEED = 250
export (float)var fire_rate = 0.5
export (float)var cooldownP1 = 2
export (float)var cooldownP2 = 3
export var stun_probability = 0
onready var rng = RandomNumberGenerator.new()
var moveDirection = Vector2(0,0)
var moveAnt = Vector2.RIGHT
var posAnt = Vector2.RIGHT
var roll_vector = Vector2.DOWN
var Mouse = Vector2.ZERO
var state = MOVE
var Can_PowerUp1 = true
var Can_PowerUp2 = true
var can_fire = true
onready var dano = 1

func _ready():
	rng.randomize()

#Constantes
const SHOT = preload("res://Assets/Shot/Shot.tscn")
const POWERUP1 = preload("res://Assets/PowerUps/Granada.tscn")
const FRICTION = 25
const DistCentro = 16
const ROLL_SPEED = 450

#Sinais
signal healthChanged(health)
signal maxhealthChanged(value)



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
	if Input.is_action_pressed("Shoot") and can_fire:
		var shots = SHOT.instance()
		shots.damage = dano
		if rng.randi_range(1, 100) <= stun_probability:
			shots.stunbullet = true
		get_parent().add_child(shots)
		shots.position = $Weapon/Position2D.global_position
		shots.rotation_degrees = $Weapon.rotation_degrees
		shots.apply_impulse(Vector2(), Vector2(shots.BULLET_SPEED, 0).rotated($Weapon.rotation))
		shots.damage = dano
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("PowerUp1") and Can_PowerUp1:
		var powerup1 = POWERUP1.instance()
		get_parent().add_child(powerup1)
		powerup1.position = $Weapon/Position2D.global_position
		powerup1.rotation_degrees = $Weapon.rotation_degrees
		powerup1.apply_impulse(Vector2(), Vector2(powerup1.BULLETSPEED, 0).rotated($Weapon.rotation))
		Can_PowerUp1 = false
		yield(get_tree().create_timer(cooldownP1), "timeout")
		Can_PowerUp1 = true
	
	if Input.is_action_just_pressed("PowerUp2") and Can_PowerUp2:
		var i = 0
		while i < 5:
			shot()
			yield(get_tree().create_timer(0.2),"timeout")
			i += 1
			
		Can_PowerUp2 = false
		yield(get_tree().create_timer(cooldownP2),"timeout")
		Can_PowerUp2 = true

func roll_state():
	$AnimationPlayer.play("Dash")
	moveDirection = roll_vector * ROLL_SPEED
	$HurtBox/CollisionShape2D.call_deferred("set","disabled", true)
	move()
#Fim das funções de estado

#Controle do movimento
func shot():
	var powerup2 = SHOT.instance()
	powerup2.stunbullet = true
	powerup2.position = $Weapon/Position2D.global_position
	powerup2.apply_impulse(Vector2(), Vector2(powerup2.BULLET_SPEED, 0).rotated($Weapon.rotation))
	get_parent().add_child(powerup2)


func control_loop():
	#Passando o movimento direto com a anulação de tecla ja feita
	moveDirection.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	moveDirection.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
#Func de direção do tiro, vê aonde o jogador esta andando e atualiza para onde ele vai atirar

	
#Func de movimento, aqui se adiciona knockback se quiser
func movement_loop(delta):
	if moveDirection != Vector2.ZERO:
		moveDirection += moveDirection.normalized() * MAX_SPEED
		roll_vector = moveDirection.normalized()
		moveAnt = moveDirection.normalized()
	else:
		moveDirection = moveDirection.move_toward(Vector2.ZERO, FRICTION * delta)
	move()

func move():
	moveDirection = move_and_slide(moveDirection)

func _on_HurtBox_area_entered(area):
	if InvunerabilityTimer.is_stopped():
		hurtbox.start_invincibility(0.4)
		InvunerabilityTimer.start(0.5)
		$AnimationPlayer.play("Flash")
		Health -= area.DAMAGE
		emit_signal("healthChanged",Health)
		if Health <= 0:
			die()

func die():
	queue_free()

func set_MaxHealth(value):
	MaxHealth += value
	emit_signal("maxhealthChanged", MaxHealth)
	
func _on_AnimationPlayer_animation_finished(_Dash):
	state = MOVE
	$HurtBox/CollisionShape2D.call_deferred("set","disabled", false)
