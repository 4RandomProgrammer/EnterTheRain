extends "res://Assets/Spawners/RandomSpawner.gd"
var can_start = false
export onready var boss = load("res://Assets/Boss/Boss1.tscn")


func _process(_delta):
	if can_start and Input.is_action_just_pressed("ui_accept"):
		create_entity_in_range(boss)
		get_parent().add_child(entity)
		queue_free()


func _on_RangeStart_body_entered(body):
	can_start = true


func _on_RangeStart_body_exited(body):
	can_start = false
