extends KinematicBody2D

#Me batendo com o git, scrr

enum {
	MOVE,
	ROLL
}

#Variaveis
onready var stats = $Stats
export (int) var MAX_SPEED = 250
export (float)var fire_rate = 0.5
var moveDirection = Vector2(0,0)
var moveAnt = Vector2.RIGHT
var posAnt = Vector2.RIGHT
var state = MOVE
var roll_vector = Vector2.DOWN
var can_fire = true

#Constantes
const SHOT = preload("res://Assets/Shot/Shot.tscn")
const POWERUP1 = preload("res://Assets/PowerUps/Granada.tscn")
const FRICTION = 25
const DistCentro = 48
const ROLL_SPEED = 450

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
	shot_dir()
	if Input.is_action_pressed("Shoot") and can_fire:
		var shots = SHOT.instance()
		shots.shotdirection(moveAnt)
		get_parent().add_child(shots)
		shots.position = $Position2D.global_position
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("ui_accept"):
		var powerup1 = POWERUP1.instance()
		powerup1.shotdir(moveAnt)
		get_parent().add_child(powerup1)
		powerup1.position = $Position2D.global_position

func roll_state():
	$AnimationPlayer.play("Dash")
	moveDirection = roll_vector * ROLL_SPEED
	$HurtBox/CollisionShape2D.call_deferred("set","disabled", true)
	move()
#Fim das funções de estado

func atualizatiro(pos):
	if pos != Vector2.ZERO:
		posAnt = pos

func control_loop():
	#Passando o movimento direto com a anulação de tecla ja feita
	moveDirection.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	moveDirection.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

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
		roll_vector = moveDirection.normalized()
		moveAnt = moveDirection.normalized()
	else:
		moveDirection = moveDirection.move_toward(Vector2.ZERO, FRICTION * delta)
	move()

func move():
	moveDirection = move_and_slide(moveDirection)



func _on_HurtBox_area_entered(area):
	stats.Health -= 1


func _on_Stats_no_health():
	queue_free()


func _on_AnimationPlayer_animation_finished(Dash):
	state = MOVE
	$HurtBox/CollisionShape2D.call_deferred("set","disabled", false)
