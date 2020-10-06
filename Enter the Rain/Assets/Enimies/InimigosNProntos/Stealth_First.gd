extends "res://Assets/Enimies/InimigosNProntos/Stealth_enemy.gd"

onready var hitbox = $Hitbox/CollisionShape2D
var can_shoot = false


const BULLET = preload("res://Assets/Enimies/Enemy_bullet/EnemyBullet.tscn")

func chase():
	#Func de stealth
	if can_stealth:
		can_stealth = false
		$StealthDuration.start(stealth_time)
		$Sprite.visible = false
		$HurtBox/CollisionShape2D.call_deferred("set", "disabled", true)
		$Hitbox/CollisionShape2D.call_deferred("set", "disabled", true)
		$CollisionShape2D.call_deferred("set", "disabled", true)
		state = STEALTH
	elif stealthTimer.is_stopped():
		stealthTimer.start(stealth_time)
	
	if can_shoot:
		shoot(enemy_range.target.position)
	elif $ShootTimer.is_stopped():  # O timer acabou, recomeçar a contagem para o proximo tiro.
		$ShootTimer.start()
	
	direction = global_position.direction_to(enemy_range.target.global_position)
	velocity = velocity.move_toward(direction * velocidade, velocidade / 2)

func shoot(pos):
	var bullet = BULLET.instance()
	var angle = (pos - global_position).angle()
	bullet.start(global_position, angle + rand_range(-0.05, 0.05))
	get_parent().add_child(bullet)
	can_shoot = false

func stealth():
	
	var dx = enemy_range.target.position.x - position.x
	var dy = enemy_range.target.position.y - position.y
	
	if(sqrt( dx * dx + dy * dy ) > 200):
		direction = global_position.direction_to(enemy_range.target.global_position)
		velocity = velocity.move_toward(direction * velocidade, velocidade / 4)
	else:
		velocity = Vector2.ZERO


func _on_StealthDuration_timeout():
	$HurtBox/CollisionShape2D.call_deferred("set", "disabled", false)
	hitbox.call_deferred("set", "disabled", false)
	$CollisionShape2D.call_deferred("set", "disabled", false)
	$Sprite.visible = true
	
	if enemy_range.entity_aimed():
			state = CHASING
	else:
		state = RANDOM_WALKING


func _on_ShootTimer_timeout():
	can_shoot = true # Replace with function body.
