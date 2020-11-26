extends KinematicBody2D

onready var rng = RandomNumberGenerator.new()
onready var min_money
var player_in_range = false
onready var item
onready var moneySystem
var player

func _ready():
	rng.randomize()
	item = item.instance()
	item.position.x = position.x
	item.position.y = position.y
	min_money = rng.randi_range(100, 300)
	$Label.text = str(min_money)


func _process(_delta):
	if player:
		# Toda vez que o player entrar no "range", verificar se ele quer abrir o bau e tem o dinheiro necessário.
		if Input.is_action_pressed("ui_select") and player.money >= min_money:
			# Atualizar dinheiro atual, spawnar o item e desaparecer com o baú.
			player.update_Money(-min_money)
			get_parent().add_child(item)
			queue_free()


func _on_Range_abrir_body_entered(body):
	player = body
	$Label2.visible = true


func _on_Range_abrir_body_exited(_body):
	player = null
	$Label2.visible = false
