extends KinematicBody2D
#Variaveis
var moveDirection = Vector2(0,0)
export (int) var MAX_SPEED = 100

#Constantes
const SHOT = preload("res://Assets/Shot/Shot.tscn")
const FRICTION = 25

func _physics_process(delta):
	control_loop()
	movement_loop(delta)
	shot_dir()
	if Input.is_action_just_pressed("Shoot"):
		var shots = SHOT.instance()
		if sign($Position2D.position.x) == 1:
			shots.shotdirection(1)
		else:
			shots.shotdirection(-1)
		get_parent().add_child(shots)
		shots.position = $Position2D.global_position
		
		
func control_loop():
	#Passando o movimento direto com a anulação de tecla ja feita
	moveDirection.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	moveDirection.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")


func shot_dir():
	if Input.is_action_just_pressed("ui_left"):
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1
	elif Input.is_action_just_pressed("ui_right"):
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1 
	
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
