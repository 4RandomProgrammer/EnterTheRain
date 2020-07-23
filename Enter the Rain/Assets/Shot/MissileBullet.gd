extends Area2D

var velocity = Vector2()
export var DAMAGE = 1
var target
var speed
var lista_mapa = ['ObjectsBehindPlayer', 'Background','Objects']

func start(pos, dir):
	position = pos
	rotation = dir
	speed = 300
	velocity = Vector2(speed, 0).rotated(dir)

func _physics_process(delta):
	position += velocity * delta
	if target:
		var wr = weakref(target)
		var space_state = get_world_2d().direct_space_state
		if wr.get_ref():  # Verificar se inimigo ainda não morreu
			var result = space_state.intersect_ray(global_position,
						target.position, [self], collision_mask)
			if result:
				if not result.collider.name in lista_mapa:
					velocity += chase()
					rotation = velocity.angle()
					

func chase():  # Retorna vetor que corrigi a direção do missil
	var desired_velocity = (target.position - position).normalized() * speed
	var rotate_speed = (desired_velocity - velocity).normalized() * 10
	return rotate_speed


func _on_VisibilityNotifier2D_screen_exited():  # Saiu da tela
	queue_free()


func _on_Area2D_body_entered(_body):  # acertou algum alvo
	queue_free()


func _on_Range_body_entered(body):  # inimigo no range
	if not body.name in lista_mapa and not target:
		target = body


func _on_Range_body_exited(body):  # inimigo saiu do range
	if target == body:
		target == null
