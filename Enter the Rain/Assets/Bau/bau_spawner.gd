extends Node2D
onready var Bau = preload("res://Assets/Bau/Bau.tscn")
export (int) var min_bau = 1
export (int) var max_bau = 1
export (int) var area_x = 100
export (int) var area_y = 100
onready var rng = RandomNumberGenerator.new()
onready var bau = Bau.instance()
var lista_de_itens = [[load("res://Assets/Itens/espada.png"), 5, 0, 0],
					  [load("res://Assets/Itens/arco.png"), 0, 0, 1000],
					  [load("res://Assets/Itens/Diamante.png"), 0, 1000, 0]]
var tamanho_lista = len(lista_de_itens)
var random_x = 0
var random_y = 0
var quant_baus = 0


func _ready():
	rng.randomize()
	quant_baus = rng.randi_range(min_bau, max_bau)
	for i in range(quant_baus):
		bau = Bau.instance()
		random_x = rand_range(global_position.x - area_x, global_position.x + area_x)
		random_y = rand_range(global_position.y - area_y, global_position.y + area_y)
		bau.position.x = random_x
		bau.position.y = random_y
		bau.lista_stats = lista_de_itens[rng.randi_range(0, tamanho_lista - 1)]
		print(lista_de_itens[rng.randi_range(0, tamanho_lista - 1)])
		get_parent().call_deferred("add_child",bau)


func _draw():
	var rect = Rect2(- area_x, - area_y, area_x * 2, area_y * 2)
	draw_rect(rect, ColorN("Red"), false)
