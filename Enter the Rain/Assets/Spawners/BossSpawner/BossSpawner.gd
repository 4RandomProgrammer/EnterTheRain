extends StaticBody2D
onready var boss_1_1 = load("res://Assets/Enimies/Boss/Boss1.tscn")
onready var boss_2_1 = load('res://Assets/Enimies/Boss/Boss2.tscn')
onready var boss_1_2 = load('res://Assets/Enimies/Boss/Boss_Snake.tscn')
onready var boss_2_2 = load('res://Assets/Enimies/Boss/Boss_spider.tscn')
onready var boss_3_1 = load('res://Assets/Enimies/Boss/Boss_turret.tscn')
onready var boss_3_2 = load('res://Assets/Enimies/Boss/Boss_3_2.tscn')
onready var boss_list = [[boss_1_1, boss_2_1], [boss_1_2, boss_2_2], [boss_3_1, boss_3_2]]
export var choosen_boss = 1
onready var altar = get_node('.')
var can_start = false

func _ready():
	hide_door()

func _process(_delta):
	if can_start and Input.is_action_just_pressed("ui_accept"):  # Player apertou para spawnar o boss (escolher um aleatorio dependendo da fase)
		randomize()
		var entities_list = boss_list[choosen_boss - 1]
		entities_list.shuffle()
		var entity = entities_list[0].instance()
		entity.position.y = position.y - 100
		entity.position.x = position.x
		hide_altar()
		unhide_door()
		get_parent().add_child(entity)
		entity.connect('Died', altar, "_on_Boss_Died")


func _on_RangeStart_body_entered(_body):
	can_start = true
	$Label.text = "Clique espaço para batalhar com o Boss!"

func _on_RangeStart_body_exited(_body):
	can_start = false
	$Label.text = ""

func hide_altar():
	$Sprite.hide()
	$CollisionShape2D.set_deferred('disabled', true)
	$RangeStart/CollisionShape2D.set_deferred('disabled', true)
	can_start = false
	$Label.text = ""

func hide_door():
	$Arena_door.set_deferred('disabled', true)
	$Sprite_door.visible = false

func unhide_door():
	$Arena_door.set_deferred('disabled', false)
	$Sprite_door.visible = true

func _on_Boss_Died():
	queue_free()
