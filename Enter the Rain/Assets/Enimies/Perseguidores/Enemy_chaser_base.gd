extends "res://Assets/Enimies/Enemy_base.gd"

export (int) var velocidade = 100
export (float) var arruma_posic = 4
onready var wanderController = $Random_moviment
onready var enemy_range = $Range
onready var screen_verification = $VisibilityNotifier2D
export var damage = 1
var state = STOPED
var velocity = Vector2.ZERO
var target
var hit_pos
var direction
var old_velocidade
var is_slowed = true
enum {
	ATTACK
	STOPED
	RANDOM_WALKING
	CHASING
	STUNNED
}


func _physics_process(_delta):  # Loop principal da torreta.
	update()
	if screen_verification.is_on_screen:
		try_aim_and_change_state()
		movimentation()
		velocity = move_and_slide(velocity)


func movimentation():
	match state:
		STOPED:  
			velocity = Vector2.ZERO
			random_state_timer()
		RANDOM_WALKING:
			direction = global_position.direction_to(wanderController.target_position)  # Pegar posic. aleatória do modulo 'movimento_aleatorio'
			velocity = velocity.move_toward(direction * velocidade, velocidade)  # Mover até essa posição aleatória.
			random_state_timer()
			if global_position.distance_to(wanderController.target_position) <= arruma_posic:  # Se chegar muito próximo da posic. aleatória, trocar de estado.
				state = pick_random_state([STOPED, RANDOM_WALKING])
				wanderController.start_wander_timer(rand_range(1, 3))
		CHASING:
			chase()
		STUNNED:
			velocity = Vector2.ZERO

func chase():
	pass

func try_aim_and_change_state():  # Tenta "mirar" no inimigo. Se conseguir, irá persegui-lo.
	if state != STUNNED:
		if enemy_range.entity_aimed():
			state = CHASING
		else:
			if state != RANDOM_WALKING and state != STOPED:  # Trocar de estado quando o alvo se esconder atrás da parede.
				player_exited_range()
				state = pick_random_state([STOPED, RANDOM_WALKING])

func player_exited_range():
	pass

func random_state_timer():  # Função que troca de estado após certo tempo.
	if wanderController.get_time_left() == 0:
		state = pick_random_state([STOPED, RANDOM_WALKING])
		wanderController.start_wander_timer(rand_range(1, 3))


func pick_random_state(state_list):  # Função que escolhe um estado aleatório.
	state_list.shuffle()
	return state_list.pop_front()


func stun_state():
	state = STUNNED
	$StunTimer.start(-1)

func slowed():
	if $SlowTimer.is_stopped():
		old_velocidade = velocidade
		$SlowTimer.start(-1)
		velocidade /= 2


func _on_Stun_timer_timeout():
	state = pick_random_state([STOPED, RANDOM_WALKING])


func _on_SlowTimer_timeout():
	velocidade = old_velocidade
