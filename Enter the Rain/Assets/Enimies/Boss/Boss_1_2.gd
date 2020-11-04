extends Node2D
var speed = 150
var damage = 1
var state = 'Spawning'
var min_timer = 1
var max_timer = 3
var timer_poison = 5
var probability_super_bullet = 5
onready var poison = load('res://Assets/Enimies/Poison.tscn')
onready var snake_head = get_node("Path2D/PathFollow2D/Corpo")
onready var poison_bullet = load('res://Assets/Enimies/Enemy_bullet/Poison_bullet.tscn')
var timer_poison_bullet = 4

signal Spawning(MaxHealth, boss_name)
signal Died
signal healthChanged(health)

func _ready():
	# Conectar os sinais com a healthBar do boss.
	var bossHealthBar = get_parent().get_parent().get_node('Player').get_node('Camera2D').get_node('CanvasLayer').get_node('HealthBarBoss')
	connect("Spawning", bossHealthBar, "_on_Boss_Spawning")
	connect("Died", bossHealthBar, "_on_Boss_Died")
	connect("healthChanged", bossHealthBar, "_on_Boss_healthChanged")
	emit_signal("Spawning", $Stats.MaxHealth, 'Roboconda')


func _on_HurtBox_area_entered(area):
	if state != 'Spawning':
		var damage_taken = area.DAMAGE
		$Stats.Health -= damage_taken
		emit_signal('healthChanged', $Stats.Health)
		


func _on_Stats_no_health():
	emit_signal('Died')
	queue_free()


func _on_Timer_timeout():
	state = 'Started'
	$Timer_veneno_corpo.start(timer_poison)
	$Timer_poison_shot.start(timer_poison_bullet)


func _on_Corpo_body_exploded():
	min_timer -= 0.1
	max_timer -= 0.2
	probability_super_bullet += 5
	speed += 15
	timer_poison -= 0.4
	timer_poison_bullet -= 0.3


func _on_Timer_veneno_corpo_timeout():
	var Poison = poison.instance()
	Poison.position = snake_head.global_position
	get_parent().call_deferred('add_child', Poison)
	$Timer_veneno_corpo.start(timer_poison)


func _on_Timer_poison_shot_timeout():
	if is_instance_valid(get_parent().get_parent().get_node('Player')):
		var poison_shot = poison_bullet.instance()
		var direction = (get_parent().get_parent().get_node('Player').global_position - snake_head.global_position).angle()
		poison_shot.start(snake_head.global_position, direction)
		get_parent().call_deferred('add_child', poison_shot)
		$Timer_poison_shot.start(timer_poison_bullet)
