extends Area2D
export (int) var min_entities
export (int) var max_entities
onready var tamanho_area_x = $CollisionShape2D.shape.extents.x
onready var tamanho_area_y = $CollisionShape2D.shape.extents.y
onready var rng = RandomNumberGenerator.new()


func create_entity_in_range(Entity):  # Criar entidade com coordenadas aleatórias dentro do range (retangular).
	var entity = Entity.instance()
	var random_x = rng.randf_range(global_position.x - tamanho_area_x, global_position.x + tamanho_area_x)
	var random_y = rng.randf_range(global_position.y - tamanho_area_y, global_position.y + tamanho_area_y)
	var entity_pos = Vector2(random_x, random_y)
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_point(entity_pos)
	if result:
		return false
	else:
		entity.global_position = Vector2(random_x, random_y)
		return entity
