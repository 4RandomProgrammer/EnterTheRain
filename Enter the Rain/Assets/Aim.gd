extends Area2D
var target
var nw
var se
var sw
var ne
var dist = 5

func entity_aimed():
	if target:
		var space_state = get_world_2d().direct_space_state
		nw = target.position - Vector2(dist, dist)  # coordenada para o canto superior esquerdo do player
		sw = target.position - Vector2(dist, -dist) # canto inferior direito
		ne = target.position - Vector2(-dist, dist)  # canto superior direito
		se = target.position - Vector2(-dist, -dist)  # canto inferior esquerdo.
		for pos in [target.position, nw, ne, se, sw]:  # Loop que vai criar todas as "miras" da torreta.
			var result = space_state.intersect_ray(global_position,
					pos, [self], collision_mask)
			if result:
				if result.collider.collision_layer != 1:  # Se alguns do raios acertar o player:
					return true


func _on_Area2D_body_entered(body):  # Player entrou no range.
	if target:
		return
	if body.collision_layer != 1:
		target = body

func _on_Area2D_body_exited(body):  # Player saiu do range.
	if body == target:
		target = null
