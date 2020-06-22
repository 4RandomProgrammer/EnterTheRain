extends KinematicBody2D

export (int) var detect_radius = 250  # Deixa que cada torreta criada tenha um "range" único (selecionavel no inspector).
export (Resource) var sprite_inimigo
export (int) var velocidade = 100
export (float) var arruma_posic = 4
onready var wanderController = $Movimento_aletorio
onready var stats = $Stats

enum {
	PARADO
	ANDANDO_ALEATORIO
	PERSEGUINDO
	VOLTANDO
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

# warning-ignore:unused_argument
func _physics_process(delta):  # Loop principal da torreta.
	update()
	if target:  # Se tem um alvo, então mire nele.
		aim()
	match state:  # Dependendo do estado, escolher a movimentação do inimigo.
		PARADO:  # Se o estado for "parado", a velocidade do inimigo deve ser 0.
			velocity = Vector2.ZERO
			random_state_timer()  # Se o tempo de troca de estado tiver passado, escolher outro estado aleatório.
			
		ANDANDO_ALEATORIO:  # Se o estado for "Andando aleatorio", andar até uma posição aleatória.
			var direcao = global_position.direction_to(wanderController.target_position)  # Pegar posic. aleatória do modulo 'movimento_aleatorio'
			velocity = velocity.move_toward(direcao * velocidade, velocidade)  # Mover até essa posição aleatória.
			random_state_timer()  # Escolher estado aleatório depois depois que o tempo passar.
			if global_position.distance_to(wanderController.target_position) <= arruma_posic:  # Se chegar muito próximo do objetivo, trocar de estado.
				state = pick_random_state([PARADO, ANDANDO_ALEATORIO])
				wanderController.start_wander_timer(rand_range(1, 3))	
				
		PERSEGUINDO:  # Se o estado for "perseguindo", andar até a posição atual do player.
			var direcao = global_position.direction_to(target.global_position)
			velocity = velocity.move_toward(direcao * velocidade, velocidade / 2)
		
		VOLTANDO:  # Se o estado for "voltando", tentar voltar até a posic. inicial do inimigo.
			var direcao = global_position.direction_to(wanderController.target_position)
			velocity = velocity.move_toward(direcao * velocidade, velocidade)
	velocity = move_and_slide(velocity)
			

func aim():
	hit_pos = []  # Uma lista que terá todas as posições das bordas do player.
	var space_state = get_world_2d().direct_space_state
	var target_extents = target.get_node('CollisionShape2D').shape.extents - Vector2(5, 5)
	var nw = target.position - target_extents  # coordenada para o canto superior esquerdo do player
	var se = target.position + target_extents  # canto superior direito
	var ne = target.position + Vector2(target_extents.x, -target_extents.y)  # canto inferior direito.
	var sw = target.position + Vector2(-target_extents.x, target_extents.y)  # canto inferior esquerdo.
	for pos in [target.position, nw, ne, se, sw]:  # Loop que vai criar todas as "miras" da torreta.
		var result = space_state.intersect_ray(position,
				pos, [self], collision_mask)
		if result:
			hit_pos.append(result.position)
			if result.collider.name == "Player":  # Fazer isso apenas se o alvo for "player":
				rotation = (target.position - position).angle()  # Girar o inimigo na direção do alvo.
				state = PERSEGUINDO  # Estado atual: perseguindo o player.
				break
			else:  # Se o alvo não ver o player por causa da parede, voltar a sua posic. antiga.
				if state != ANDANDO_ALEATORIO and state != PARADO:
					state = pick_random_state([PARADO, ANDANDO_ALEATORIO])  # Para isso, usar o state voltando

				
func random_state_timer():  # Função que troca de estado após certo tempo.
	if wanderController.get_time_left() == 0:
		state = pick_random_state([PARADO, ANDANDO_ALEATORIO])
		wanderController.start_wander_timer(rand_range(1, 3))
		

func pick_random_state(state_list):  # Função que escolhe estado aleatório.
	state_list.shuffle()
	return state_list.pop_front()

func _on_Alcance_body_entered(body):
	if target:  # Se já tinha um alvo, então ignorar.
		return
	target = body  # Se chegou até aqui, ainda não tinha alvo, e o novo alvo agora é quem entrou no range.


func _on_Alcance_body_exited(body):
	state = pick_random_state([PARADO, ANDANDO_ALEATORIO])
	if body == target:  # Se quem saiu era o alvo:
		target = null  # Definir que o alvo agora é ninguém.


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
