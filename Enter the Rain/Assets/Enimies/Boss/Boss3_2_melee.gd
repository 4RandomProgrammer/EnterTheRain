extends KinematicBody2D

onready var stats = $Stats_melee
onready var timer_sword_hit = $Timer_hit
onready var player = get_parent().get_parent().get_node('Player')
enum {
	SPAWNING,
	SWORD_HIT,
	NORMAL,
	KNOCKED
}
var initial_x_pos
var hit_delay_time = 0.5
var sword_hit_duration = 0.3
var atacking = false
var damage = 1
var state = SPAWNING
var speed = 250
var velocity = Vector2.ZERO

signal Spawning
signal healthChanged
signal Died


func _ready():
	initial_x_pos = position.x - 75
	# Conectando os sinais:
	var bossHealthBar1 = get_parent().get_parent().get_node('Player').get_node('Camera2D').get_node('CanvasLayer').get_node('HealthBarBoss')
	connect("Spawning", bossHealthBar1, "_on_Boss_Spawning")
	connect("healthChanged", bossHealthBar1, "_on_Boss_healthChanged")
	emit_signal("Spawning", stats.MaxHealth)

func _physics_process(delta):
	match state:
		NORMAL:
			if is_instance_valid(player):
				var direction = global_position.direction_to(player.position)
				velocity = velocity.move_toward(direction * speed * delta, speed / 2)
				rotation = direction.angle()
				move_and_collide(velocity)
				if global_position.distance_to(player.global_position) <= 60:
					timer_sword_hit.start(hit_delay_time)
					state = SWORD_HIT

func _on_HurtBox_area_entered(area):
	if state != SPAWNING and state != KNOCKED:
		var damage_taken = area.DAMAGE
		stats.Health -= damage_taken
		emit_signal('healthChanged', stats.Health)


func _on_Timer_spawn_timeout():
	state = NORMAL

func _on_Stats_melee_no_health(): # Inimigo foi "nocauteado".
	state = KNOCKED
	$Sprite.self_modulate.r = 0.2

func revive():
	$Sprite.self_modulate.r = 1.0
	stats.Health = 15
	emit_signal('healthChanged', stats.Health)
	state = NORMAL


func _on_Timer_hit_timeout():
	if not atacking:
		$Sword_hitbox/CollisionShape2D.disabled = false
		$Sprite_hit_sword.visible = true
		atacking = true
		timer_sword_hit.start(sword_hit_duration)
	else:
		$Sword_hitbox/CollisionShape2D.disabled = true
		$Sprite_hit_sword.visible = false
		atacking = false
		state = NORMAL
