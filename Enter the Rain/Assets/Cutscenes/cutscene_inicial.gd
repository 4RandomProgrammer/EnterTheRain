extends Node2D

onready var text_container = get_node("Log")
onready var letter_timer = get_node("Letters_timer")
onready var msg_espaco = get_node("Pres_espaco")

var logs_texts = [
	"Data: 29/01/2149\n\n\nStatus: Um novo vírus é catalogado nos Estados Unidos. Sua aparição começou a chamar atenção depois de um pequeno surto em Massachusetts. O Vírus é extremamente infeccioso mas não apresenta nenhum perigo até o momento. Os infectados que apresentam sintomas mais fortes estão sendo tratados em centros médicos de pesquisa. A situação está sob supervisão e sob controle. Nenhuma informação sobre o vírus foi revelada ao público.",
	"Data: 06/09/2149\n\n\nStatus: Não é mais possível manter a existência do vírus em sigilo. A sua taxa de transmissão está aumentando em níveis astronômicos, agora não somente infectando humanos, como qualquer matéria orgânica. Foi notado também que o vírus realiza mutações no infectado, o tornando irreconhecível em o que ele era antes.\nMutações variam de aumento de massa muscular a desfiguramento completo com novos apêndices e até mesmo outras formas de locomoção. O vírus foi batizado de Divoc-91 e diversos países lutam para a sua aniquilação.\nAinda não foi descoberto a sua origem e a sua forma de transmissão.",
	"Data: 09/11/2149\n\n\nStatus: A Terra foi completamente tomada pelo Divoc-91. Os sobreviventes da catástrofe fugiram da Terra a bordo da nave GLDF Esperança. Dentro dessa nave, uma organização é formada para manter a ordem e tomar decisões críticas para a sobrevivência da raça humana, a organização é batizada de Conselho de Comando.\nJunto com a criação do Conselho de Comando, uma outra organização é criada, com a intenção de continuar as pesquisas que haviam sido realizadas na terra para a aniquilação do Divoc-91. Essa organização é batizada como D.A.D. (Divisão de Aniquilação do Divoc-91) e é dirigida pelo Dr. Francis Hermiton.",
	"Data: 13/02/2177\n\n\nStatus: A Terra ainda está sob a sombra do Divoc-91. Dr. Francis e seu time ainda não conseguiram nenhum progresso contra o vírus e os suprimentos da nave estão começando a acabar.\nContudo a equipe de inteligência D.A.D. conseguiu interceptar mensagens criptografadas com a origem da Terra. D.A.D conseguiu decodificar as mensagens e após a sua leitura, Dr. Francis decide convocar uma reunião com o Conselho de Comando.\nNa reunião é revelado que as mensagens decodificadas possuem coordenadas de regiões na Terra que podem conter algum tipo de cura ou pista do Divoc-91.\nO Conselho de Comando decide montar uma força tarefa de super soldados com um único objetivo: Voltar à Terra e encontrar a cura, ou morrer tentando."
]

var current_log_index = 0
var text_espaco_load_log = "Pressione espaço para carregar log completo"
var text_espaco_next_log = "Pressione espaço para carregar próximo log"


func _ready():
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
		queue_free()


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
		queue_free()
	else:
		# Carregar próximo texto e começar a mostrar na tela
		current_log_index += 1
		text_container.text = logs_texts[current_log_index]
		text_container.percent_visible = 0
		letter_timer.start()
		msg_espaco.text = text_espaco_load_log
