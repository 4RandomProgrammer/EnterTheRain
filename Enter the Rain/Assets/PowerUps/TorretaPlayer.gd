extends KinematicBody2D

const Bullet = preload("res://Assets/Shot/Shot.tscn")
onready var turret_range = $Range
onready var stats = $Stats
var can_shoot = true

signal Spawned
signal dead

func _ready():
	connect("Spawned",get_parent().get_node("Player"),"turret_spawned")
	connect("dead",get_parent().get_node("Player"),"turret_dead")
	emit_signal("Spawned")
	pass

func _physics_process(delta):
	update()
	try_aim_player_and_shoot()

func try_aim_player_and_shoot():
	if turret_range.entity_aimed():
		rotation = (turret_range.target.position - position).angle()
		if can_shoot:
			shoot(turret_range.target.position)

func shoot(pos):
	pass


func _on_Stats_no_health():
	emit_signal("dead")
	queue_free()
