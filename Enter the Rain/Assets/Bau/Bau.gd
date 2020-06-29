extends KinematicBody2D

onready var rng = RandomNumberGenerator.new()
onready var min_money
var player_in_range = false
onready var item
onready var moneySystem

func _ready():
	rng.randomize()
	item = item.instance()
	item.position.x = position.x
	item.position.y = position.y
	min_money = rng.randi_range(100, 500)
	$Label.text = str(min_money)


func _process(_delta):
	move_and_slide(Vector2.ZERO)
	if player_in_range:
		# Toda vez que o player entrar no "range", verificar se ele quer abrir o bau e tem o dinheiro necessário.
		moneySystem = get_parent().get_node("Sistema_Dinheiro")
		if Input.is_action_pressed("ui_select") and moneySystem.dinheiro >= min_money:
			# Atualizar dinheiro atual, spawnar o item e desaparecer com o baú.
			moneySystem.atualiza_dinheiro(min_money)
			get_parent().add_child(item)
			queue_free()


func _on_Range_abrir_body_entered(_body):
	player_in_range = true


func _on_Range_abrir_body_exited(_body):
	player_in_range = false
