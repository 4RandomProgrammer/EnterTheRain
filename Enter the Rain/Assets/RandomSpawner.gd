extends Area2D
export (int) var min_entities
export (int) var max_entities
onready var tamanho_area_x = $CollisionShape2D.shape.extents.x
onready var tamanho_area_y = $CollisionShape2D.shape.extents.y
onready var rng = RandomNumberGenerator.new()
var entity


func create_entity_in_range(par_entity):  # Criar entidade com coordenadas aleatórias dentro do range (retangular).
	entity = par_entity.instance()
	var random_x = rng.randf_range(global_position.x - tamanho_area_x, global_position.x + tamanho_area_x)
	var random_y = rng.randf_range(global_position.y - tamanho_area_y, global_position.y + tamanho_area_y)
	entity.global_position = Vector2(random_x, random_y)
