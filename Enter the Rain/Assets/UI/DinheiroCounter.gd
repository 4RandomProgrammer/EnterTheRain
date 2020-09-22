extends MarginContainer

onready var dinheiros = $Dinheiro


func _on_Player_moneyChanged(current_money):
	dinheiros.text = str(current_money)
