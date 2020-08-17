extends StaticBody2D
onready var boss_1_1 = load("res://Assets/Enimies/Boss/Boss1.tscn")
onready var boss_2_1 = load('res://Assets/Enimies/Boss/Boss2.tscn')
onready var boss_1_2 = load('res://Assets/Enimies/Boss/Boss_Snake.tscn')
onready var boss_list = [[boss_1_1, boss_1_2], [boss_2_1]]
export var choosen_boss = 1
var can_start = false


func _process(_delta):
	if can_start and Input.is_action_just_pressed("ui_accept"):  # Player apertou para spawnar o boss (escolher um aleatorio dependendo da fase)
		var entities_list = boss_list[choosen_boss - 1]
		entities_list.shuffle()
		var entity = entities_list[0].instance()
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
