extends "res://Assets/Enimies/InimigosNProntos/Enemy_attack_base.gd"

var can_move = false
var teleporting = false

const normal = preload("res://Assets/Sprites/golem.png")
const attack = preload("res://Assets/Sprites/golem_attack.png")

func chase():
	if can_move:
		can_move = false
		tp()
	elif $MoveTimer.is_stopped():
		$MoveTimer.start(0.5)

func tp():
	var dx = enemy_range.target.position.x - position.x
	var dy = enemy_range.target.position.y - position.y
	var dir =  global_transform.origin.direction_to ( enemy_range.target.global_transform.origin )
	var _enemy_radius = $HurtBox/CollisionShape2D.get_shape().radius
	teleporting = true
	$Sprite.set_texture(attack)
	move_and_collide(dir * (sqrt( dx * dx + dy * dy ) - 64) )
	

func _on_MoveTimer_timeout():
	can_move = true
