extends KinematicBody2D

onready var Item = load("res://Assets/Itens/Itens.tscn")
var dinheiro = 0
export (int) var dinheiro_necessario = -1
var rng = RandomNumberGenerator.new()
export (Resource) var sprite_bau = load("res://Assets/Bau/bau_placeholder.png")
export var lista_stats = []
var player_no_range = false
var item


func _ready():
	print(lista_stats)
	$Sprite.texture = sprite_bau
	rng.randomize()
	if dinheiro_necessario < 0:
		dinheiro_necessario = rng.randi_range(100, 500)
	$Label.text = str(dinheiro_necessario)
	item = Item.instance()
	item.sprite = lista_stats[0]
	item.dano = lista_stats[1]
	item.velocidade = lista_stats[2]
	item.atack_speed = lista_stats[3]
	item.global_position = global_position


func _process(delta):
	move_and_slide(Vector2.ZERO)
	if player_no_range:
		dinheiro = get_parent().get_node("Sistema_Dinheiro").dinheiro
		if Input.is_action_pressed("ui_select") and dinheiro >= dinheiro_necessario:
			get_parent().get_node("Sistema_Dinheiro").dinheiro -= dinheiro_necessario
			get_parent().add_child(item)
			queue_free()


func _on_Range_abrir_body_entered(body):
	player_no_range = true


func _on_Range_abrir_body_exited(body):
	player_no_range = false
