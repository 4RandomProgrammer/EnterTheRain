extends Control

onready var player = get_parent().get_parent().get_parent()
onready var itens_UI_panel = load("res://Assets/Itens/Itens_UI_panel.tscn")
onready var sprite_popup = get_node("Sprite_popup")
onready var label_popup = get_node('Label_popup')
onready var timer_popup = get_node("Timer_popup")
var itens_popups_queue = []
var itens_UI_dict = {}


func update_itens_UI(item):
	if not item.name == "Life":
		if item.name in itens_UI_dict:  # O item atual já foi coletado uma vez
			itens_UI_dict[item.name][0] += 1  # Aumentar a quantidade do item coletado
			# Atualizar texto
			itens_UI_dict[item.name][1].get_node("Label").text = 'x' + str(itens_UI_dict[item.name][0])
		else:  # Primeira vez que o item foi coletado
			# Adiciona-lo ao dicionário e instanciar o item na UI.
			var itens_ui = itens_UI_panel.instance()
			itens_UI_dict[item.name] = [1, itens_ui]
			itens_ui.get_node("Sprite").texture = item.get_parent().sprite
			itens_ui.get_node("Label").text = 'x1'
			get_node("HBoxContainer").add_child(itens_ui)


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
