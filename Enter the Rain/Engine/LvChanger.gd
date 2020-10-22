extends StaticBody2D

var player = null
export var nextlevel = "res://Assets/Areas/TestArea.tscn"

func _physics_process(_delta):
	if player != null and Input.is_action_just_pressed("ui_accept"):
		pass

func _on_Area2D_body_entered(body):
	player = get_parent().get_node("Player")


func _on_Area2D_body_exited(_body):
	player = null
