extends StaticBody2D
onready var boss = load("res://Assets/Enimies/Boss/Boss1.tscn")
var can_start = false


func _process(_delta):
	if can_start and Input.is_action_just_pressed("ui_accept"):
		var entity = boss.instance()
		entity.position.y = position.y - 100
		entity.position.x = position.x
		get_parent().add_child(entity)
		queue_free()


func _on_RangeStart_body_entered(_body):
	can_start = true
	$Label.text = "Clique espaço para batalhar com o Boss!"

func _on_RangeStart_body_exited(_body):
	can_start = false
	$Label.text = ""
