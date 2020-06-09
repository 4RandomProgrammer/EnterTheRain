extends Node2D

var dinheiro = 0


func _ready():
	 pass
	

func aumenta_dinheiro(dinheiro_recebido):
	dinheiro += dinheiro_recebido
	print(dinheiro)
