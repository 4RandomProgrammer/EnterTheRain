extends CollisionShape2D
onready var Bau = preload("res://Assets/Bau/Bau.tscn")
export (int) var min_bau_spawns = 1
export (int) var max_bau_spawns = 1
onready var tamanho_area_x = shape.extents.x
onready var tamanho_area_y = shape.extents.y
onready var rng = RandomNumberGenerator.new()
onready var bau = Bau.instance()
# Lista_de_itens possue todos itens existentes no jogo.
# Carregar a imagem, dano, velocidade e atack speed em cada item nessa lista.
var lista_de_itens = [[load("res://Assets/Itens/espada.png"), 5, 0, 0],
					  [load("res://Assets/Itens/arco.png"), 0, 0, 1000],
					  [load("res://Assets/Itens/Diamante.png"), 0, 1000, 0]]
var tamanho_lista = len(lista_de_itens)
var random_x_position
var random_y_position
var quant_baus


func _ready():
	rng.randomize()
	quant_baus = rng.randi_range(min_bau_spawns, max_bau_spawns)
	for _i in range(quant_baus):
		# Spawnar os baus com posições aleatórias no range dado.
		bau = Bau.instance()
		# Escolher posição aleatória para o bau (dentro do range).
		random_x_position = rand_range(global_position.x - tamanho_area_x, global_position.x + tamanho_area_x)
		random_y_position = rand_range(global_position.y - tamanho_area_y, global_position.y + tamanho_area_y)
		bau.position.x = random_x_position
		bau.position.y = random_y_position
		bau.lista_stats = lista_de_itens[rng.randi_range(0, tamanho_lista - 1)]  # Escolher um item aleatório para o baú.
		get_parent().call_deferred("add_child",bau)


func _draw():
	# Desenhar o range de spawn de baus.
	var rect2 = Rect2(- tamanho_area_x,- tamanho_area_y, tamanho_area_x * 2, tamanho_area_y *2)
	draw_rect(rect2, ColorN("Yellow"), false)
