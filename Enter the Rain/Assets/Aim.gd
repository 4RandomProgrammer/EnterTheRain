extends Area2D
var target

func aim():
	if target:
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
				if result.collider.name == "Player":  # Fazer isso apenas se o alvo for "player":
					return true
				else:
					return false


func _on_Area2D_body_entered(body):
	if target:
		return
	target = body

func _on_Area2D_body_exited(body):
	if body == target:
		target = null
