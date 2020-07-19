extends Control

onready var sprite_popup = get_node("Sprite_popup")
onready var label_popup = get_node('Label_popup')
onready var timer_popup = get_node("Timer_popup")
var itens_popups_queue = []
var itens_UI_dict = {
	'AtackSpeed': {'sprite':load("res://Assets/Itens/Itens_sprites/Bow1.png"),
				   'description':'Aumenta a sua velocidade de ataque', 'count':0},
	'Damage':     {'sprite':load("res://Assets/Itens/Itens_sprites/Sword1.png"), 
				   'description':'Aumenta o seu dano', 'count':0},
	'ExtraShots': {'sprite':load("res://Assets/Itens/Itens_sprites/Sword_2.png"), 
				   'description':'Aumenta a probabilidade de atirar tiros extras', 'count':0},
	'Missile':    {'sprite':load("res://Assets/Enemy_bullet/missile00.png"),
				   'description':'Aumenta a probabilidade de soltar misseis teleguiados', 'count':0},
	'MaxHealth':  {'sprite':load("res://Assets/Itens/Itens_sprites/Diamond2.png"),
				   'description':'Aumenta a sua vida máxima', 'count':0},
	'MoveSpeed':  {'sprite':load("res://Assets/Itens/Itens_sprites/Diamond1.png"),
				   'description':'Aumenta a sua velocidade de movimento', 'count':0},
	'StunProb':   {'sprite':load("res://Assets/Itens/Itens_sprites/Staff1.png"),
				   'description':'Aumenta a probabilidade de atirar balas atordoantes', 'count':0}
}

func _ready():
	pass # Replace with function body.


func _on_ItemCollectArea_area_entered(item):
	var item_sprite = itens_UI_dict[item.name]['sprite']
	var item_description = itens_UI_dict[item.name]['description']
	print(timer_popup.time_left)
	if timer_popup.time_left == 0:
		sprite_popup.texture = item_sprite
		label_popup.text = item_description
		sprite_popup.visible = true
		label_popup.visible = true
		timer_popup.start()
	itens_popups_queue.append([item_sprite, item_description])


func _on_Timer_popup_timeout():
	itens_popups_queue.pop_front()
	print(timer_popup.time_left)
	print(itens_popups_queue)
	if not itens_popups_queue:
		sprite_popup.visible = false
		label_popup.visible = false
	else:
		sprite_popup.texture = itens_popups_queue[0][0]
		label_popup.text = itens_popups_queue[0][1]
		timer_popup.start()
