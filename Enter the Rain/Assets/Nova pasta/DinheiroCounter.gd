extends MarginContainer

onready var dinheiros = $Dinheiro




func _on_Sistema_Dinheiro_dinheiro_recebido(value):
	dinheiros.text = str(value)
