extends Area2D
var target

func player_aimed():
	if target:
		var space_state = get_world_2d().direct_space_state
		var target_extents = target.get_node('CollisionShape2D').shape.extents - Vector2(5, 5)
		var nw = target.position - target_extents  # coordenada para o canto superior esquerdo do player
		var se = target.position + target_extents  # canto inferior direito
		var ne = target.position + Vector2(target_extents.x, -target_extents.y)  # canto superior direito
		var sw = target.position + Vector2(-target_extents.x, target_extents.y)  # canto inferior esquerdo.
		for pos in [target.position, nw, ne, se, sw]:  # Loop que vai criar todas as "miras" da torreta.
			var result = space_state.intersect_ray(global_position,
					pos, [self], collision_mask)
			if result:
				if result.collider.name == "Player":  # Se alguns do raios acertar o player:
					return true
	return false


func _on_Area2D_body_entered(body):  # Player entrou no range.
	if target:
		return
	if body.name == 'Player':
		target = body

func _on_Area2D_body_exited(body):  # Player saiu do range.
	if body == target:
		target = null
