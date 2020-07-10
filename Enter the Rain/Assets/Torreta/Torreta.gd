extends KinematicBody2D
enum {
	NORMAL,
	STUNNED
}
var Bullet = load("res://Assets/Enemy_bullet/EnemyBullet.tscn")
onready var turret_range = $Range
onready var stats = $Stats
onready var screen_verification = $VisibilityNotifier2D
var can_shoot = true
var state = NORMAL
var rng = RandomNumberGenerator.new()


func _physics_process(_delta):
	if screen_verification.is_on_screen:
		move_and_slide(Vector2.ZERO)
		match state:
			NORMAL:
				update()
				try_aim_player_and_shoot()
			STUNNED:
				pass


func try_aim_player_and_shoot():  # Função que tentará atirar no player. Só atirará quando tiver no range e sem obstaculos na frente.
	if turret_range.player_aimed():
		rotation = (turret_range.target.position - position).angle()
		if can_shoot:
			shoot(turret_range.target.position)


func shoot(pos):  # Função que atira na direção do player.
	var bullet = Bullet.instance()
	var angle = (pos - global_position).angle()
	bullet.start(global_position, angle + rand_range(-0.05, 0.05))
	get_parent().add_child(bullet)
	can_shoot = false  # Após um tiro, deve-se dar um delay para o próximo tiro.
	$ShootTimer.start()


func _on_ShootTimer_timeout():  # Quando acabar esse tempo, torreta pode atirar novamente.
	can_shoot = true


func _on_HurtBox_area_entered(area):  # Torreta foi atingida.
	var damage = area.DAMAGE
	stats.Health -= damage


func _on_Stats_no_health():
	# Chamada quando a torreta morrer, player receberá dinheiro e a torreta sumirá.
	rng.randomize()
	var money = get_parent().get_node("Sistema_Dinheiro")
	money.aumenta_dinheiro(rng.randi_range(30, 60))
	queue_free()


func stun_state():
	state = STUNNED
	$StunTimer.start(-1)


func _on_StunTimer_timeout():
	state = NORMAL
