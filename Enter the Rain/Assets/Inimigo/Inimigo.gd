extends KinematicBody2D

export (int) var detect_radius = 250  # Deixa que cada torreta criada tenha um "range" único (selecionavel no inspector).
export (Resource) var sprite_inimigo
export (int) var velocidade = 100
export (float) var arruma_posic = 4
onready var wanderController = $Movimento_aletorio
onready var alcance = $Alcance
onready var stats = $Stats


enum {
	PARADO
	ANDANDO_ALEATORIO
	PERSEGUINDO
	ESTUNADO
}

var state = PARADO
var velocity = Vector2.ZERO
var target
var hit_pos


func _ready():
	var shape = CircleShape2D.new() 
	shape.radius = detect_radius  # Cria o "range" com o raio selecionado.
	$Alcance/CollisionShape2D.shape = shape  # Coloca o "range" na torreta.
	if sprite_inimigo:
		$Sprite.texture = sprite_inimigo

func _physics_process(_delta):  # Loop principal da torreta.
	update()
	movimentation()
	velocity = move_and_slide(velocity)


func movimentation():
	match state:  # Dependendo do estado, escolher a movimentação do inimigo.
		PARADO:  # Se o estado for "parado", a velocidade do inimigo deve ser 0.
			aim()
			velocity = Vector2.ZERO
			random_state_timer()  # Se o tempo de troca de estado tiver passado, escolher outro estado aleatório.
			
		ANDANDO_ALEATORIO:  # Se o estado for "Andando aleatorio", andar até uma posição aleatória.
			aim()
			var direcao = global_position.direction_to(wanderController.target_position)  # Pegar posic. aleatória do modulo 'movimento_aleatorio'
			velocity = velocity.move_toward(direcao * velocidade, velocidade)  # Mover até essa posição aleatória.
			random_state_timer()  # Escolher estado aleatório depois depois que o tempo passar.
			if global_position.distance_to(wanderController.target_position) <= arruma_posic:  # Se chegar muito próximo do objetivo, trocar de estado.
				state = pick_random_state([PARADO, ANDANDO_ALEATORIO])
				wanderController.start_wander_timer(rand_range(1, 3))
				
		PERSEGUINDO:  # Se o estado for "perseguindo", andar até a posição atual do player.
			if not alcance.target:
				state = pick_random_state([PARADO, ANDANDO_ALEATORIO])
			else:
				aim()
				var direcao = global_position.direction_to(alcance.target.global_position)
				velocity = velocity.move_toward(direcao * velocidade, velocidade / 2)
		ESTUNADO:
			velocity = Vector2.ZERO


func aim():
	if alcance.aim():
		state = PERSEGUINDO
	else:
		if state != ANDANDO_ALEATORIO and state != PARADO:
			state = pick_random_state([PARADO, ANDANDO_ALEATORIO])  # Para isso, usar o state voltando


func random_state_timer():  # Função que troca de estado após certo tempo.
	if wanderController.get_time_left() == 0:
		state = pick_random_state([PARADO, ANDANDO_ALEATORIO])
		wanderController.start_wander_timer(rand_range(1, 3))
		

func pick_random_state(state_list):  # Função que escolhe estado aleatório.
	state_list.shuffle()
	return state_list.pop_front()


func _on_HurtBox_area_entered(area):
	var dano = area.DAMAGE
	stats.Health -= dano


func _on_Stats_no_health():
	# Chamada quando o inimigo morrer, player receberá dinheiro e o inimigo sumirá.
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var din = get_parent().get_node("Sistema_Dinheiro")
	din.aumenta_dinheiro(rng.randi_range(30,60))
	queue_free()


func stun_state():
	state = ESTUNADO
	$StunTimer.start(-1)


func _on_StunTimer_timeout():
	state = pick_random_state([PARADO, ANDANDO_ALEATORIO])
