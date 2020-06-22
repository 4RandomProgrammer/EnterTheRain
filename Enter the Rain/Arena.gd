extends CollisionShape2D

export (int) var min_enemies
export (int) var max_enemies
onready var Torreta = load("res://Assets/Torreta/Torreta.tscn")
onready var Inimigo = load("res://Assets/Inimigo/Inimigo.tscn")
onready var tamanho_area_x = shape.extents.x
onready var tamanho_area_y = shape.extents.y
var enemy


func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var repeticoes = rng.randi_range(min_enemies, max_enemies)  # Número de vezes que irá spawnar.
	for _i in range(repeticoes):
		var tipo_inimigo = rng.randi_range(0, 1)
		var random_x = rng.randf_range(global_position.x - tamanho_area_x, global_position.x + tamanho_area_x)
		var random_y = rng.randf_range(global_position.y - tamanho_area_y, global_position.y + tamanho_area_y)
		if tipo_inimigo == 0:
			enemy = Torreta.instance()
		else:
			enemy = Inimigo.instance()
		enemy.position.x = random_x
		enemy.position.y = random_y
		get_parent().call_deferred("add_child",enemy)


func _draw():  # Desenhar o range da arena.
	var rect = Rect2(- tamanho_area_x, - tamanho_area_y, tamanho_area_x * 2, tamanho_area_y * 2)
	draw_rect(rect, ColorN("Red"), false)  # "Range".
