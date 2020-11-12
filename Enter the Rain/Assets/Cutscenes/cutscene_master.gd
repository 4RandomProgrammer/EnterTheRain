extends Node2D

onready var text_container = get_node("Log")
onready var letter_timer = get_node("Letters_timer")
onready var msg_espaco = get_node("Pres_espaco")

var logs_texts

var current_log_index = 0
var text_espaco_load_log = "Pressione espaço para carregar log completo"
var text_espaco_next_log = "Pressione espaço para carregar próximo log"


func _ready():
	on_ready()
	text_container.text = logs_texts[current_log_index]
	msg_espaco.text = text_espaco_load_log


func _process(_delta):
	if Input.is_action_just_pressed("ui_select"):
		if text_container.percent_visible == 1:
			# Usuário apertou espaço para ir para o proximo log.
			load_next_log()
		else:
			# Usuário apertou espaço para motrar o log completo.
			text_container.percent_visible = 1
			msg_espaco.text = text_espaco_next_log
	if Input.is_action_just_pressed("ui_cancel"):
		on_finish()


func _on_Letters_timer_timeout():
	# Mostrar texto de log letra a letra
	if text_container.percent_visible != 1:
		text_container.visible_characters += 1
		letter_timer.start()
	else:
		msg_espaco.text = text_espaco_next_log


func load_next_log():
	if current_log_index == len(logs_texts) - 1:
		# Acabou os textos. Acabou a cutscene.
		on_finish()
	else:
		# Carregar próximo texto e começar a mostrar na tela
		current_log_index += 1
		text_container.text = logs_texts[current_log_index]
		text_container.percent_visible = 0
		letter_timer.start()
		msg_espaco.text = text_espaco_load_log

func on_finish():
	pass

func on_ready():
	pass
