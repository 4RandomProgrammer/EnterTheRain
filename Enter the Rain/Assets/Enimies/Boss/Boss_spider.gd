extends KinematicBody2D

var damage = 1
enum {
	SPAWNING,
	WALKING,
	MOVE_POWER
}
var speed = 150
var state = SPAWNING
onready var stats = $Stats
onready var player = get_parent().get_parent().get_node('Player')
onready var minion = load('res://Assets/Enimies/Boss/Boss_spider_minion.tscn')
onready var rng = RandomNumberGenerator.new()
onready var random_moviment = $Movimento_aletorio
onready var Bullet = load("res://Assets/Enimies/Enemy_bullet/EnemyBullet.tscn")
onready var Super_bullet = load("res://Assets/Enimies/Enemy_bullet/SuperBullet.tscn")
onready var Cobweb_bullet = load("res://Assets/Enimies/Enemy_bullet/Cobweb_bullet.tscn")
onready var Power_cobweb = load('res://Assets/Enimies/Enemy_bullet/Cobweb_bul_power.tscn')
onready var Explosion = load("res://Assets/Enimies/Explosion.tscn")
var bullet_list = []
var direction
var velocity = Vector2.ZERO

signal Spawning
signal Died
signal healthChanged

func _physics_process(delta):
	match state:
		SPAWNING:
			pass
		WALKING:
			movimentation(delta)
		MOVE_POWER:
			pass
		

func movimentation(delta):  # Movimento "aleatório" da aranha
	direction = global_position.direction_to(random_moviment.target_position)  # Pegar a direção para uma posição aleatória (definido no node "movimento_aleatorio")
	velocity = velocity.move_toward(direction * delta * speed, speed * delta)
	var colision = move_and_collide(velocity)
	if colision or global_position.distance_to(random_moviment.target_position) <= 10:  # Se bater ou chegar muito perto do destino: trocar posic. aleatoria.
		random_moviment.update_target_position()

func _ready():
	randomize()
	# Conectando os sinais:
	var bossHealthBar = get_parent().get_parent().get_node('Player').get_node('Camera2D').get_node('CanvasLayer').get_node('HealthBarBoss')
	connect("Spawning", bossHealthBar, "_on_Boss_Spawning")
	connect("Died", bossHealthBar, "_on_Boss_Died")
	connect("healthChanged", bossHealthBar, "_on_Boss_healthChanged")
	emit_signal("Spawning", $Stats.MaxHealth, 'SP1D3ROTRON 3000')

func _on_HurtBox_area_entered(area):
	if state != SPAWNING:
		var damage_taken = area.DAMAGE
		stats.Health -= damage_taken
		emit_signal('healthChanged', stats.Health)

func _on_Stats_no_health():
	emit_signal('Died')
	queue_free() 


func _on_Timer_spawn_timeout():
	state = WALKING
	$Timer_minions.start()
	$Timer_start_shoot.start()


func _on_Timer_minions_timeout():  # Spawnar minions
	for _i in range(rng.randi_range(1, 3)):
		var Minion = minion.instance()
		Minion.global_position = Vector2(global_position.x + rand_range(-32, 32), global_position.y + rand_range(-32, 32))
		Minion.player = player
		get_parent().call_deferred('add_child', Minion)

func create_bullet_list_and_start_shooting():  # Criará uma lista com 5 bullets (1 fragmentadora, 1 de teia e 3 normais)
	for _i in range(3):
		var bullet = Bullet.instance()
		bullet_list.append(bullet)
	var super_bullet = Super_bullet.instance()
	bullet_list.append(super_bullet)
	var cobweb_bullet = Cobweb_bullet.instance()
	bullet_list.append(cobweb_bullet)
	bullet_list.shuffle()  # Randomizar a ordem das bullets
	$Timer_delay_shoot.start()


func _on_Timer_start_shoot_timeout():
	create_bullet_list_and_start_shooting()


func _on_Timer_delay_shoot_timeout():  # Atirar as bullets criadas.
	if bullet_list and is_instance_valid(player):  # Se ainda não tiver atirado todos os tiros, continuar atirando...
		var current_bullet = bullet_list[0]
		current_bullet.start(global_position, (player.position - position).angle())
		bullet_list.pop_front()
		get_parent().call_deferred('add_child', current_bullet)
		$Timer_delay_shoot.start()


func _on_Timer_spider_up_timeout():
	state = MOVE_POWER
	$AnimationPlayer.play("GoUp")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'GoUp':  # Aranha acabou de subir na teia
		position = player.position
		$AnimationPlayer.play("GoDown")
	else:  # Aranha acabou de descer da teia
		# Executar poder 2
		var explosion = Explosion.instance()
		explosion.position = position
		get_parent().call_deferred('add_child', explosion)
		var angle = 0
		while angle < 2 * PI:
			var cobweb_bullet = Power_cobweb.instance()
			cobweb_bullet.start(global_position, angle)
			get_parent().call_deferred('add_child', cobweb_bullet)
			angle += PI / 4
		state = WALKING
