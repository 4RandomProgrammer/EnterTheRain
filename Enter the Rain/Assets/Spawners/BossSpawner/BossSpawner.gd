extends StaticBody2D
onready var Boss_PONG = load('res://Assets/Enimies/Boss/Boss_PONG.tscn')
onready var Boss_SOLDIER = load('res://Assets/Enimies/Boss/Boss_SOLDIER.tscn')
onready var Boss_ROBOCONDA = load('res://Assets/Enimies/Boss/Boss_ROBOCONDA.tscn')
onready var Boss_SPIDERTRON = load('res://Assets/Enimies/Boss/Boss_SPIDERTRON.tscn')
onready var Boss_GUARDIAN = load('res://Assets/Enimies/Boss/Boss_GUARDIAN.tscn')
onready var Boss_DOUBLE = load('res://Assets/Enimies/Boss/Boss_DOUBLE.tscn')
onready var boss_list = [[Boss_PONG, Boss_ROBOCONDA], [Boss_SOLDIER, Boss_SPIDERTRON], [Boss_GUARDIAN, Boss_DOUBLE]]
export var choosen_boss = 0
export var music_player = 0
onready var altar = get_node('.')
var can_start = false

func _ready():
	hide_door()

func _process(_delta):
	if can_start and Input.is_action_just_pressed("ui_accept"):  # Player apertou para spawnar o boss (escolher um aleatorio dependendo da fase)
		randomize()
		Mensageiro.playmusic(music_player)
		var entities_list = boss_list[choosen_boss]
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
