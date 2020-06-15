extends Area2D

export (int) var detect_area_x
export (int) var detect_area_y
export (int) var min_enemies
export (int) var max_enemies
onready var rect_area = Vector2(detect_area_x, detect_area_y)
onready var Torreta = load("res://Assets/Torreta/Torreta.tscn")
onready var Inimigo = load("res://Assets/Inimigo/Inimigo.tscn")
var fix_pos = 32
var spawn = true
var enemies_list = []


func _ready():
	var shape = RectangleShape2D.new()
	shape.extents = rect_area
	$CollisionShape2D.shape = shape
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	var repeticoes = rand.randi_range(min_enemies, max_enemies)  # Número de vezes que irá spawnar.
	for _i in range(repeticoes):
		var tipo_inimigo = rand.randi_range(0, 1)
		var random_x = rand.randf_range(global_position.x - detect_area_x, global_position.x + detect_area_x)
		var random_y = rand.randf_range(global_position.y - detect_area_y, global_position.y + detect_area_y)
		if tipo_inimigo == 0:
			var torre = Torreta.instance()
			torre.position.x = random_x
			torre.position.y = random_y
			enemies_list.append(torre)
		else:
			var inimigo = Inimigo.instance()
			inimigo.position.x = random_x
			inimigo.position.y = random_y
			enemies_list.append(inimigo)


func _draw():  # Desenha o raio laser e o range da torre. (decidir se isso vai ficar ou não no jogo).
	var rect = Rect2(- rect_area.x, - rect_area.y, rect_area.x * 2, rect_area.y * 2)
	draw_rect(rect, ColorN("Yellow"), false)  # "Range".



func _on_Arena_body_entered(_body):
	if spawn:
		spawn = false
		for enemy in enemies_list:
			get_parent().add_child(enemy)
