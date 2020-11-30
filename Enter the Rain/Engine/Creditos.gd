extends ColorRect

onready var text_container = $Text
onready var letter_timer = $LetterTimer

var text = [
				"Fernando Favareto Abromovick\n\tGame Design e Artes\n\nGregorio Fornetti\n\tGame Design e Programacao\n\nGiovanini\n\tGame Design e coordenacao do projeto\n\nLuis Henriques\n\tGame Design e Programacao\n\nDouglas Chen Ishimoto\nMusicas\n\nAgradecimentos especiais\n\nUnnamed pelo  Sci Fi Tileset no chefe final\n\nKenney pelo Roguelike Modern City pack no terceiro level\n\nTrueCynder pelo Forest Tileset New and Old com a paleta de cores de\nCalciumtrice Outdoor TileSet no segundo nivel\n\nJetrel pelo Explosion Animations\n\nDanilo Inafuku\nAnderson Garrote\nAndre Bariani\n\nObrigado a todos por tornarem esse projeto real"
			]

func _on_LetterTimer_timeout():
	# Mostrar texto de log letra a letra
	if text_container.percent_visible != 1:
		text_container.visible_characters += 1
		letter_timer.start()


func _on_Creditos_pressed():
	text_container.text = text[0]
	text_container.percent_visible = 0
	letter_timer.start()


func _on_Button_pressed():
	self.visible = false
