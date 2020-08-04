extends Area2D
var target
var target_list = []
var dist = 5
var positions

func entity_aimed():
	if target_list:
		target = target_list[0]
		update()
		if not weakref(target).get_ref():  # Alvo acabou de morrer...
			target_list.remove(0)
			return
		var space_state = get_world_2d().direct_space_state
		if "RectangleShape" in target.get_node('CollisionShape2D').shape.to_string():
			positions = aim_rectangle_borders()
		elif "CapsuleShape" in target.get_node('CollisionShape2D').shape.to_string():
			positions = aim_capsule_borders()
		elif "CircleShape" in target.get_node('CollisionShape2D').shape.to_string():
			positions = aim_circle_borders()
		else:
			positions = aim_general_borders()
		positions.append(target.position)
		for pos in positions:  # Loop que vai criar todas as "miras" da torreta.
			var result = space_state.intersect_ray(global_position,
					pos, [self], collision_mask)
			if result:
				if result.collider.collision_layer != 1:  # Se alguns do raios acertar o player:
					return true


func aim_rectangle_borders():
	var target_extents = target.get_node('CollisionShape2D').shape.extents - Vector2(5, 5)
	var positions_list = []
	positions_list.append(target.position - target_extents)  # canto superior esquerdo
	positions_list.append(target.position + target_extents)  # canto inferior direito
	positions_list.append(target.position + Vector2(target_extents.x, -target_extents.y))  # canto superior direito
	positions_list.append(target.position + Vector2(-target_extents.x, target_extents.y))  # canto inferior esquerdo.
	return positions_list

func aim_capsule_borders():
	var fix_dist = 0
	var positions_list = []
	var height = target.get_node("CollisionShape2D").shape.height - fix_dist
	var radius = target.get_node("CollisionShape2D").shape.radius - fix_dist
	positions_list.append(Vector2(target.position.x, target.position.y - height)) # Canto superior
	positions_list.append(Vector2(target.position.x, target.position.y + height))  # Canto inferior
	positions_list.append(Vector2(target.position.x + radius, target.position.y))  # Canto direito
	positions_list.append(Vector2(target.position.x - radius, target.position.y)) # Canto esquerdo
	return positions_list

func aim_circle_borders():
	var fix_dist = 3
	var positions_list = []
	var radius = target.get_node("CollisionShape2D").shape.radius - fix_dist
	positions_list.append(Vector2(target.position.x, target.position.y - radius))  # Canto superior
	positions_list.append(Vector2(target.position.x, target.position.y + radius))  # Canto inferior
	positions_list.append(Vector2(target.position.x + radius, target.position.y))  # Canto direito
	positions_list.append(Vector2(target.position.x - radius, target.position.y))  # Canto esquerdo
	return positions_list

func aim_general_borders():
	var dist = 5
	var positions_list = []
	positions_list.append(target.position + Vector2(-dist, -dist))  # canto superior esquerdo
	positions_list.append(target.position + Vector2(-dist, dist)) # canto inferior direito
	positions_list.append(target.position + Vector2(dist, -dist))  # canto superior direito
	positions_list.append(target.position + Vector2(dist, dist))  # canto inferior esquerdo.
	return positions_list

func _on_Area2D_body_entered(body):  # Player entrou no range.
	if body.collision_layer != 1:
		target_list.append(body)

func _on_Area2D_body_exited(body):  # Player saiu do range.
	if body == target:
		target_list.erase(body)
