extends KinematicBody2D

enum {
	MOVE,
	ROLL,
	PW1,
	PW2
}

export(int) var  MaxHealth = 1
export (int) var MAX_SPEED = 250
export (float)var fire_rate = 0.5
export (float)var cooldownP1 = 2
export (float)var cooldownP2 = 3
onready var InvunerabilityTimer = $HurtBox/Timer
onready var hurtbox = $HurtBox
onready var Health = MaxHealth
var posAnt = Vector2.RIGHT
var roll_vector = Vector2.DOWN
var Mouse = Vector2.ZERO
var state = MOVE
var Can_PowerUp1 = true
var Can_PowerUp2 = true
var can_fire = true
var dano = 1
var moveDirection = Vector2.ZERO

const FRICTION = 25
const SHOT = preload("res://Assets/Shot/Shot.tscn")

#Sinais
signal healthChanged(health)
signal maxhealthChanged(value)
signal no_health

func _physics_process(delta):
	#Maquina de estados
	match state:
		MOVE:
			estado_base(delta)

		ROLL:
			roll_state()

func roll_state():
	pass

func estado_base(delta):
	pass

func set_MaxHealth(value):
	MaxHealth += value
	emit_signal("maxhealthChanged", MaxHealth)

#Func de tiro
func shot(isStunBullet):
	var shots = SHOT.instance()
	get_parent().add_child(shots)
	shots.stunbullet = isStunBullet
	shots.position = $Weapon/Position2D.global_position
	shots.rotation_degrees = $Weapon.rotation_degrees
	shots.apply_impulse(Vector2(), Vector2(shots.BULLET_SPEED, 0).rotated($Weapon.rotation))

func die():
	queue_free()

#Func de inputs
func control_loop():
	#Passando o movimento direto com a anulação de tecla ja feita
	moveDirection.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	moveDirection.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

#Func de movimento, aqui se adiciona knockback se quiser
func movement_loop(delta):
	if moveDirection != Vector2.ZERO:
		moveDirection += moveDirection.normalized() * MAX_SPEED
		roll_vector = moveDirection.normalized()
	else:
		moveDirection = moveDirection.move_toward(Vector2.ZERO, FRICTION * delta)
	move()

func move():
	moveDirection = move_and_slide(moveDirection)

func _on_HurtBox_area_entered(area):
	if InvunerabilityTimer.is_stopped():
		InvunerabilityTimer.start(0.5)
		$AnimationPlayer.play("Flash")
		Health -= area.DAMAGE
		emit_signal("healthChanged",Health)
		if Health <= 0:
			emit_signal("no_health")
			die()

func _on_PowerUp1CD_timeout():
	Can_PowerUp1 = true

func _on_PowerUP2CD_timeout():
	Can_PowerUp2 = true

func _on_ShotCD_timeout():
	can_fire = true
