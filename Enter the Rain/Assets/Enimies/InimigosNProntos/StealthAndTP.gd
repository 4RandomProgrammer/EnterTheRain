extends "res://Assets/Enimies/InimigosNProntos/Stealth_enemy.gd"

var can_move = true
onready var hitbox = $Hitbox/CollisionShape2D

func chase():
	
	if can_stealth:
		can_stealth = false
		$StealthDuration.start(stealth_time)
		$Sprite.visible = false
		$HurtBox/CollisionShape2D.call_deferred("set", "disabled", true)
		hitbox.call_deferred("set", "disabled", true)
		$CollisionShape2D.call_deferred("set", "disabled", true)
		state = STEALTH
	elif stealthTimer.is_stopped():
		stealthTimer.start(stealth_time)
	
	velocity = move_and_slide(Vector2.ZERO)

func stealth():
	if can_move:
		can_move = false
		tp()
	elif $MoveTimer.is_stopped():
		$MoveTimer.start(0.5)

func _on_StealthDuration_timeout():
	$HurtBox/CollisionShape2D.call_deferred("set", "disabled", false)
	hitbox.call_deferred("set", "disabled", false)
	$CollisionShape2D.call_deferred("set", "disabled", false)
	$Sprite.visible = true
	
	if enemy_range.entity_aimed():
		if player != null:
			attackduration.start(attack_cooldown)
			state = ATTACK
		state = CHASING
	else:
		state = RANDOM_WALKING

func tp():
	var dx = enemy_range.target.position.x - position.x
	var dy = enemy_range.target.position.y - position.y
	var dir =  global_transform.origin.direction_to ( enemy_range.target.global_transform.origin )
	move_and_collide(dir * (sqrt( dx * dx + dy * dy ) + 64) )

func _on_MoveTimer_timeout():
	can_move = true
