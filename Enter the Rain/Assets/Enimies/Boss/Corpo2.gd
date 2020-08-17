extends KinematicBody2D
onready var path_follow = get_parent()
onready var main_node = get_parent().get_parent().get_parent()
onready var stats = get_parent().get_parent().get_parent().get_node('Stats')
export(int) var health_to_explode
onready var explosion = load('res://Assets/Enimies/Explosion.tscn')
onready var bullet = load('res://Assets/Enimies/Enemy_bullet/EnemyBullet.tscn')
onready var super_bullet = load('res://Assets/Enimies/Enemy_bullet/SuperBullet.tscn')
var rng = RandomNumberGenerator.new()
var damage = 1
var started = false
signal body_exploded

func ready():
	rng.randomize()
	
func _physics_process(delta):
	rng.randomize()
	var speed = main_node.speed
	if started:
		path_follow.set_offset(path_follow.get_offset() + speed * delta)
	if stats.Health <= health_to_explode:
		explode()
	

func _on_Timer_timeout():  # Iniciar a locomoção
	started = true
	$Timer_shot.start(rng.randf_range(main_node.min_timer, main_node.max_timer))

func explode():
	# Explodir a parte do corpo
	var Explosion = explosion.instance()
	Explosion.position = global_position
	main_node.get_parent().call_deferred('add_child', Explosion)
	# Atirar algumas bullets
	var direction = 0
	while direction < 2 * PI:
		var bullet_spawn = bullet.instance()
		bullet_spawn.start(global_position, direction)
		main_node.get_parent().call_deferred('add_child', bullet_spawn)
		direction += PI / 5
	emit_signal("body_exploded")
	queue_free()


func _on_Timer_shot_timeout():  # Shoot to a random location
	var Bullet
	if rng.randi_range(0, 100) <= main_node.probability_super_bullet:
		Bullet = super_bullet.instance()
	else:
		Bullet = bullet.instance()
	Bullet.start(global_position, rng.randf_range(0, 360))
	main_node.get_parent().call_deferred('add_child', Bullet)
	$Timer_shot.start(rng.randf_range(main_node.min_timer, main_node.max_timer))
