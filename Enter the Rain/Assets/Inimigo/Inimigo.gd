extends KinematicBody2D

export (int) var velocidade = 100
export (float) var arruma_posic = 4
onready var wanderController = $Random_moviment
onready var enemy_range = $Range
onready var stats = $Stats
onready var screen_verification = $VisibilityNotifier2D
export var damage = 1
var state = STOPED
var velocity = Vector2.ZERO
var target
var hit_pos
var direction
enum {
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
			if not enemy_range.target:  # Player saiu do range. Hora de mudar de estado
				state = pick_random_state([STOPED, RANDOM_WALKING])
			else:
				direction = global_position.direction_to(enemy_range.target.global_position)
				velocity = velocity.move_toward(direction * velocidade, velocidade / 2)
		STUNNED:
			velocity = Vector2.ZERO


func try_aim_and_change_state():  # Tenta "mirar" no inimigo. Se conseguir, irá persegui-lo.
	if state != STUNNED:
		if enemy_range.player_aimed():
			state = CHASING
		else:
			if state != RANDOM_WALKING and state != STOPED:  # Trocar de estado quando o alvo se esconder atrás da parede.
				state = pick_random_state([STOPED, RANDOM_WALKING])


func random_state_timer():  # Função que troca de estado após certo tempo.
	if wanderController.get_time_left() == 0:
		state = pick_random_state([STOPED, RANDOM_WALKING])
		wanderController.start_wander_timer(rand_range(1, 3))
		

func pick_random_state(state_list):  # Função que escolhe um estado aleatório.
	state_list.shuffle()
	return state_list.pop_front()


func _on_HurtBox_area_entered(area):
	var dano = area.DAMAGE
	print(damage)
	stats.Health -= dano


func _on_Stats_no_health():
	# Chamada quando o inimigo morrer, player receberá dinheiro e o inimigo sumirá.
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var money = get_parent().get_node("Sistema_Dinheiro")
	money.aumenta_dinheiro(rng.randi_range(30,60))
	queue_free()


func stun_state():
	state = STUNNED
	$StunTimer.start(-1)


func _on_StunTimer_timeout():
	state = pick_random_state([STOPED, RANDOM_WALKING])
