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

#Sinais
signal healthChanged(health)
signal maxhealthChanged(value)

func _physics_process(delta):
	#Maquina de estados
	match state:
		MOVE:
			estado_base(delta)

		ROLL:
			print(MAX_SPEED)
			roll_state()

func roll_state():
	pass

func estado_base(delta):
	pass

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
