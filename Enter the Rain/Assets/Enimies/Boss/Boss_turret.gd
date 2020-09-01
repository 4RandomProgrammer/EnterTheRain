extends KinematicBody2D

onready var rng = RandomNumberGenerator.new()
var damage = 1
onready var stats = $Stats
onready var player = get_parent().get_node('Player')
var player_positions_list = []
var displaying_laser = false
enum {
	SPAWNING,
	NORMAL,
	LASER
}
var state = SPAWNING

signal healthChanged(health)
signal Spawning(maxHealth)
signal Died

func _physics_process(delta):
	match state:
		SPAWNING:
			pass
		NORMAL:
			print(player_positions_list)
			pass
		LASER:
			player_positions_list.append(player.global_position)
			if displaying_laser:
				rotation = (player_positions_list[0] - global_position).angle()
				player_positions_list.pop_front()

func _ready():
	rng.randomize()
	# Conectando os sinais do HealthBar do boss
	var bossHealthBar = get_parent().get_node('Player').get_node('Camera2D').get_node('CanvasLayer').get_node('HealthBarBoss')
	var boss_turret = get_node('.')
	boss_turret.connect("Spawning", bossHealthBar, "_on_Boss_Spawning")
	boss_turret.connect("Died", bossHealthBar, "_on_Boss_Died")
	boss_turret.connect("healthChanged", bossHealthBar, "_on_Boss_healthChanged")
	emit_signal("Spawning", $Stats.MaxHealth)


func _on_HurtBox_area_entered(area):
	if state != SPAWNING:
		var damage_taken = area.DAMAGE
		stats.Health -= damage_taken
		emit_signal("healthChanged", stats.Health)

func _on_Stats_no_health():
	emit_signal('Died')
	queue_free()


func _on_Timer_spawn_timeout():
	state = NORMAL


func _on_Timer_change_pow_timeout():
	var power_choosen = rng.randi_range(1, 3)
	if power_choosen:
		state = LASER
		$Timer_laser.start(0.3)


func _on_Timer_laser_timeout():
	if not displaying_laser:
		# Ativar o laser por 5 secs
		$Laser/Sprite.visible = true
		displaying_laser = true
		$Timer_laser.start(5)
	else:
		# Hora de desativar o laser
		$Laser/Sprite.visible = false
		displaying_laser = false
		state = NORMAL
		player_positions_list.clear()
