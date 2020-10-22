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

func spawn_entities(entities_list):
	rng.randomize()
	var entities_quant = rng.randi_range(min_entities, max_entities)  # Escolher quantidade aleatoria no range de inimigos para spawnar
	while entities_quant != 0:
		var entity_index = rng.randi_range(0, len(entities_list) - 1)  # Escolher um dos 2 inimigos para spawnar.
		var entity = create_entity_in_range(entities_list[entity_index])
		if entity:
			get_parent().call_deferred("add_child", entity)
			entities_quant -= 1
