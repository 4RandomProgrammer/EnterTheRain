extends KinematicBody2D

enum {
	MOVE,
	ROLL
}

#Variaveis
var moveDirection = Vector2(0,0)
export (int) var MAX_SPEED = 200
var moveAnt = Vector2.RIGHT
var posAnt = Vector2.RIGHT
var state = MOVE
var roll_vector = Vector2.DOWN

#Constantes
const SHOT = preload("res://Assets/Shot/Shot.tscn")
const FRICTION = 25
const DistCentro = 48
const ROLL_SPEED = 4000

func _physics_process(delta):
	#Maquina de estados
	match state:
		MOVE:
			estado_base(delta)

		ROLL:
			roll_state(delta)


#Func para os estados
func estado_base(delta):
	control_loop()
	movement_loop(delta)
	shot_dir()
	if Input.is_action_just_pressed("Shoot"):
		var shots = SHOT.instance()
		shots.shotdirection(moveAnt)
		get_parent().add_child(shots)
		shots.position = $Position2D.global_position
	if Input.is_action_just_pressed("Roll"):
		state = ROLL

func roll_state(delta):
	moveDirection += roll_vector * ROLL_SPEED
	move()
	state = MOVE
#Fim das funções de estado

func atualiza(movedir):
	if movedir != Vector2.ZERO:
		roll_vector = movedir
		moveAnt = movedir

func atualizatiro(pos):
	if pos != Vector2.ZERO:
		posAnt = pos

func control_loop():
	#Passando o movimento direto com a anulação de tecla ja feita
	moveDirection.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	moveDirection.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	atualiza(moveDirection)

func shot_dir():
	var Posicao = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		Posicao += Vector2.LEFT
	elif Input.is_action_pressed("ui_right"):
		Posicao += Vector2.RIGHT
	if Input.is_action_pressed("ui_up"):
		Posicao += Vector2.UP
	elif Input.is_action_pressed("ui_down"):
		Posicao += Vector2.DOWN
	
	atualizatiro(Posicao)
	
	$Position2D.set_position(posAnt.normalized() * DistCentro)
	
#Func de movimento, aqui se adiciona knockback se quiser
func movement_loop(delta):
	if moveDirection != Vector2.ZERO:
		moveDirection += moveDirection.normalized() * MAX_SPEED
	else:
		moveDirection = moveDirection.move_toward(Vector2.ZERO, FRICTION * delta)
	move()

func move():
	moveDirection = move_and_slide(moveDirection)

