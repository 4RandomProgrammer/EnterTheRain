extends "res://Assets/Enimies/Enemy_bullet/EnemyBullet.gd"

onready var Explosion = load("res://Assets/Enimies/Explosion.tscn")
onready var Mini_bullet = load("res://Assets/Enimies/Enemy_bullet/BossMiniBullet.tscn")
var exploded = false

func _ready():
	$Timer_explode.start(rand_range(1, 3))


func _on_Timer_explode_timeout():
	if not exploded:  # Hora de parar e soltar os tiros que vai e voltam.
		velocity = Vector2.ZERO
		spawn_bullets()
		$CollisionShape2D.call_deferred('disabled', true)
		$Sprite.visible = false
		exploded = true
		$Timer_explode.start(2)
	elif exploded:  # Hora soltar uma explosão, os tiros voltaram.
		var explosion = Explosion.instance()
		explosion.global_position = global_position
		get_parent().call_deferred('add_child', explosion)
		queue_free()

func spawn_bullets():
	var angle = 0
	while angle < PI * 2:
		var mini_bullet = Mini_bullet.instance()
		mini_bullet.start(global_position, angle)
		get_parent().call_deferred('add_child', mini_bullet)
		angle += PI /4
