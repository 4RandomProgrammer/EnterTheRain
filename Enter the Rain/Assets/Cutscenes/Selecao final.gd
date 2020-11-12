extends Node2D

onready var Cutscene_final = preload("res://Assets/Cutscenes/Cutscene_final.tscn")
signal changeLv
	

func ready():
	connect('changeLv', get_parent().get_parent().get_parent().get_parent(), '_on_LvChanger_changeLv')

func _on_Button_continue_pressed():
	get_parent().get_parent().get_parent().get_parent().instanciarlevel()
	emit_signal('changeLv')
	queue_free()


func _on_Button_finish_pressed():
	get_parent().call_deferred('add_child', Cutscene_final.instance())
	queue_free()
