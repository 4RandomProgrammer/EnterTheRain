extends "res://Assets/Cutscenes/cutscene_master.gd"

func on_ready():
	logs_texts = [
		"Data: 17/06/2177\n\n\nStatus: Parece que um dos soldados enviados retornou. Muitos foram enviados para procurar a cura, mas parece que esses ainda não voltaram. Esse soldado que retornou diz ter encontrado a cura e que o cientista responsável pela cura, foi o mesmo criador do vírus.\nEntão, seria esse um plano arquitetado ou algum louco que quis dominar o mundo?",
		"Data: 24/07/2177\n\n\nStatus: Após vários testes, foi comprovado a veracidade da cura que o soldado encontrou. O Conselho de Comando decide voltar todas as suas forças para administrar a cura para o restante da Terra e retornar para o seu planeta.",
		"Data: 19/09/2177\n\n\nStatus: O Conselho de Comando consegue erradicar o Divoc-91 da Terra.\nContudo, a Terra que conhecíamos não existe mais. Agora, florestas se tornaram selvas com seres que não se parecem com animais, plantações se tornaram desertos inabitáveis e cidades se tornaram ruínas da nossa civilização.\nSeja lá quem foi você, Dr. Lastra, e o que você queria provar, parabéns. Agora isso não é mais a Terra, é somente um fantasma, que nos assombra e nos faz lembrar daquilo que um dia fomos."
	]

func on_finish():
	assert(get_tree().change_scene("res://StartMenu/StartMenu.tscn") == OK)
