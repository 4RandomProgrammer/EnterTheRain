extends Node2D

var dinheiro = 0
	

func aumenta_dinheiro(dinheiro_recebido):
	# Essa função será chamada toda vez que um inimigo morre.
	dinheiro += dinheiro_recebido
	print(dinheiro)
