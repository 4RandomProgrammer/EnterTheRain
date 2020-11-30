extends StaticBody2D

var player = null
signal changeLv


func _ready():
	connect('changeLv', get_parent(), '_on_LvChanger_changeLv')

func _physics_process(_delta):
	if player != null and Input.is_action_just_pressed("ui_accept"):
		emit_signal("changeLv")

func _on_Area2D_body_entered(body):
	player = body
	$Label.visible = true
	$Label2.visible = true


func _on_Area2D_body_exited(_body):
	player = null
	$Label.visible = false
	$Label2.visible = false
