extends KinematicBody2D

onready var Item = load("res://Assets/Itens/Itens.tscn")
var dinheiro = 0
export (int) var dinheiro_necessario = -1
var rng = RandomNumberGenerator.new()
export (Resource) var sprite_bau = load("res://Assets/Bau/bau_placeholder.png")
export var lista_stats = []
var player_no_range = false
var item
onready var sistemadinheiro

func _ready():
	$Sprite.texture = sprite_bau
	rng.randomize()
	if dinheiro_necessario < 0:  # Dinheiro para abrir bau é por padrão aleatório.
		dinheiro_necessario = rng.randi_range(100, 500)
	$Label.text = str(dinheiro_necessario)
	# Carregar item selecionado aleatoriamente na cena "bau_spawner".
	item = Item.instance()
	item.sprite = lista_stats[0]
	item.dano = lista_stats[1]
	item.velocidade = lista_stats[2]
	item.atack_speed = lista_stats[3]
	item.global_position = global_position
	


func _process(_delta):
	move_and_slide(Vector2.ZERO)
	if player_no_range:
		# Toda vez que o player entrar no "range", verificar se ele quer abrir o bau e tem o dinheiro necessário.
		dinheiro = get_parent().get_node("Sistema_Dinheiro").dinheiro
		#Não gosto dessa solução,mas foi o punico jeito que pensei no momento
		sistemadinheiro = get_parent().get_node("Sistema_Dinheiro")
		if Input.is_action_pressed("ui_select") and dinheiro >= dinheiro_necessario:
			# Atualizar dinheiro atual, spawnar o item e desaparecer com o baú.
			sistemadinheiro.atualiza_dinheiro(dinheiro_necessario)
			get_parent().add_child(item)
			queue_free()


func _on_Range_abrir_body_entered(_body):
	player_no_range = true


func _on_Range_abrir_body_exited(_body):
	player_no_range = false
