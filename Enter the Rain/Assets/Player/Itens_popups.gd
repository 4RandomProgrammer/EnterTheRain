extends Control

onready var player = get_parent().get_parent().get_parent()
onready var painel_teste = load("res://Teste_painel.tscn")
onready var sprite_popup = get_node("Sprite_popup")
onready var label_popup = get_node('Label_popup')
onready var timer_popup = get_node("Timer_popup")
var itens_popups_queue = []
var itens_UI_dict = {
	'AtackSpeed':0,
	'Damage':0,
	'ExtraShots':0,
	'Missile':0,
	'MaxHealth':0,
	'MoveSpeed':0,
	'StunProb':0,
	'LifeSteal':0
}

func update_itens_UI(item):
	var teste = painel_teste.instance()
	get_node("HBoxContainer").add_child(teste)


func _on_ItemCollectArea_area_entered(item):
	if item.name != 'Life' or not player.Health != player.MaxHealth:
		update_itens_UI(item)
		var item_sprite = item.get_parent().sprite
		var item_description = item.get_parent().description
		if timer_popup.time_left == 0:
			# Não há popups no momento, portanto, precisa voltar a visibilidade.
			sprite_popup.texture = item_sprite
			label_popup.text = item_description
			sprite_popup.visible = true
			label_popup.visible = true
			timer_popup.start()
		itens_popups_queue.append([item_sprite, item_description])


func _on_Timer_popup_timeout():
	itens_popups_queue.pop_front()
	if not itens_popups_queue:
		# Acabou os itens da lista, popup deve ficar invisivel,
		sprite_popup.visible = false
		label_popup.visible = false
	else:
		# Ainda existem itens na lista, hora de mostrar o próximo.
		sprite_popup.texture = itens_popups_queue[0][0]
		label_popup.text = itens_popups_queue[0][1]
		timer_popup.start()
