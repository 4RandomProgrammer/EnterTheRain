extends KinematicBody2D

export (int) var detect_radius  # Deixa que cada torreta criada tenha um "range" único (selecionavel no inspector).
export (float) var fire_rate  # Deixa que cada torreta criada tenha uma taxa de tiro única.
export (PackedScene) var Bullet  # Deixa empacotar um objeto, que será o tiro da torreta.
var vis_color = Color(.867, .91, .247, 0.1)
var laser_color = Color(1.0, .329, .298)

var target
var hit_pos
var can_shoot = true

func _ready():
	var shape = CircleShape2D.new() 
	shape.radius = detect_radius  # Cria o "range" com o raio selecionado.
	$Alcance/CollisionShape2D.shape = shape  # Coloca o "range" na torreta.
	$ShootTimer.wait_time = fire_rate  # Define o tempo de demora para cada tiro sair.

func _physics_process(delta):  # Loop principal da torreta.
	update()
	if target:  # Se tem um alvo, então mire nele.
		aim()

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
				$Sprite.self_modulate.r = 1.0  # Deixa a sprite com suas cores normais.
				rotation = (target.position - position).angle()  # Girar a maquina na direção do alvo.
				if can_shoot:  # Atirar apenas quando possível (após o timer deixar).
					shoot(pos)
				break

func shoot(pos):  # Função que atira no alvo quando possível.
	var b = Bullet.instance()  # Cria o tiro.
	var a = (pos - global_position).angle()  # Direção do tiro.
	b.start(global_position, a + rand_range(-0.05, 0.05))  # Atirar na direção do alvo.
	get_parent().add_child(b)
	can_shoot = false  # Após um tiro, deve-se dar um delay para o próximo tiro.
	$ShootTimer.start()

func _draw():  # Desenha o raio laser e o range da torre. (decidir se isso vai ficar ou não no jogo).
	draw_circle(Vector2(), detect_radius, vis_color)  # "Range".
	if target:
		for hit in hit_pos:
			draw_circle((hit - position).rotated(-rotation), 5, laser_color)  # Circulo no alvo atingido.
			draw_line(Vector2(), (hit - position).rotated(-rotation), laser_color)  # Linha até o alvo.

func _on_Alcance_body_entered(body):  # Um alvo entrou no "range".
	if target:  # Se já tinha um alvo, então ignorar.
		return
	target = body  # Se chegou até aqui, ainda não tinha alvo, e o novo alvo agora é quem entrou no range.


func _on_Alcance_body_exited(body):  # Um alvo saiu do "range".
	if body == target:  # Se quem saiu era o alvo:
		target = null  # Definir que o alvo agora é ninguém.
		$Sprite.self_modulate.r = 0.2  # Deixa a sprite com um tom de cor mais fraco.

func _on_ShootTimer_timeout():  # "Fire rate" da torreta.
	can_shoot = true

