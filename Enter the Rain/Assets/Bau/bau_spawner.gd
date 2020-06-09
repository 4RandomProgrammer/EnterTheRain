extends Node2D
onready var Bau = preload("res://Assets/Bau/Bau.tscn")
export (int) var min_bau = 1
export (int) var max_bau = 1
export (int) var area_x = 100
export (int) var area_y = 100
var rect_area = Vector2(area_x, area_y)
onready var rng = RandomNumberGenerator.new()
onready var bau = Bau.instance()
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
		bau.position.x = random_x - global_position.x
		bau.position.y = random_y - global_position.y
		add_child(bau)


func _draw():
	var rect = Rect2(- rect_area.x, - rect_area.y, rect_area.x * 2, rect_area.y * 2)
	draw_rect(rect, ColorN("Red"), false)
