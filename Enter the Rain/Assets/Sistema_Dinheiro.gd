extends Node2D

var dinheiro = 0
signal dinheiro_recebido(value)
	

func aumenta_dinheiro(dinheiro_recebido):
	# Essa função será chamada toda vez que um inimigo morre.
	dinheiro += dinheiro_recebido
	emit_signal("dinheiro_recebido",dinheiro)
	
	print(dinheiro)

func atualiza_dinheiro(value):
	dinheiro -= value
	emit_signal("dinheiro_recebido",dinheiro)
