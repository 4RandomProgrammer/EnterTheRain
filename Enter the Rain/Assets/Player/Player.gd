extends KinematicBody2D

#Variaveis
var moveDirection = Vector2(0,0)
export (int) var MAX_SPEED = 200
var moveAnt = Vector2.RIGHT

#Constantes
const SHOT = preload("res://Assets/Shot/Shot.tscn")
const FRICTION = 25
const DistCentro = 48

func _physics_process(delta):
	control_loop()
	movement_loop(delta)
	shot_dir()
	if Input.is_action_just_pressed("Shoot"):
		var shots = SHOT.instance()
		shots.shotdirection(moveAnt)
		get_parent().add_child(shots)
		shots.position = $Position2D.global_position


func atualiza(movedir):
	if movedir != Vector2.ZERO:
		moveAnt = movedir

func control_loop():
	#Passando o movimento direto com a anulação de tecla ja feita
	moveDirection.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	moveDirection.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	atualiza(moveDirection)

func shot_dir():
	var Position = Vector2.ZERO
	if Input.is_action_just_pressed("ui_left"):
		Position += Vector2.LEFT
	elif Input.is_action_just_pressed("ui_right"):
		Position += Vector2.RIGHT
	if Input.is_action_just_pressed("ui_up"):
		Position += Vector2.UP
	elif Input.is_action_just_pressed("ui_down"):
		Position += Vector2.DOWN
	
	$Position2D.set_position(position.normalized())

#Func de movimento, aqui se adiciona knockback se quiser
func movement_loop(delta):
	if moveDirection != Vector2.ZERO:
		moveDirection += moveDirection.normalized() * MAX_SPEED
	else:
		moveDirection = moveDirection.move_toward(Vector2.ZERO, FRICTION * delta)
	moveDirection = move_and_slide(moveDirection)

#Dxar essa função caso eu queira usar o mouse para atirar
func mouse_shoot():
	var look_vec = get_global_mouse_position() - global_position
	global_rotation = atan2(look_vec.y, look_vec.x)
