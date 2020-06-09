extends KinematicBody2D

onready var Item = load("res://Assets/Itens/Itens.tscn")
var dinheiro = 0
export (int) var dinheiro_necessario = rand_range(100, 500)
export (Resource) var sprite_bau = load("res://Assets/Bau/bau_placeholder.png")
var player_no_range = false


func _ready():
	$Sprite.texture = sprite_bau


func _process(delta):
	move_and_slide(Vector2.ZERO)
	if player_no_range:
		dinheiro = get_parent().get_parent().get_node("Sistema_Dinheiro").dinheiro
		if Input.is_action_pressed("ui_select") and dinheiro >= dinheiro_necessario:
			get_parent().get_parent().get_node("Sistema_Dinheiro").dinheiro -= dinheiro_necessario
			var item = Item.instance()
			item.position = global_position
			get_parent().get_parent().add_child(item)
			queue_free()


func _on_Range_abrir_body_entered(body):
	player_no_range = true


func _on_Range_abrir_body_exited(body):
	player_no_range = false
