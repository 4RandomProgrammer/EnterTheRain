extends "res://Assets/Enimies/Enemy_base.gd"

enum {
	NORMAL,
	STUNNED
}
onready var turret_range = $Range
onready var screen_verification = $VisibilityNotifier2D
var can_shoot = true
var state = NORMAL
export var damage = 1
var rng = RandomNumberGenerator.new()


func _physics_process(_delta):
	update()
	if screen_verification.is_on_screen:
		move_and_slide(Vector2.ZERO)
		match state:
			NORMAL:
				update()
				try_aim_player_and_shoot()
			STUNNED:
				pass


func try_aim_player_and_shoot():  # Função que tentará atirar no player. Só atirará quando tiver no range e sem obstaculos na frente.
	pass

func shoot(pos):  # Função que atira na direção do player.
	pass

func _on_ShootTimer_timeout():  # Quando acabar esse tempo, torreta pode atirar novamente.
	can_shoot = true


func stun_state():
	state = STUNNED
	$StunTimer.start(-1)


func _on_StunTimer_timeout():
	state = NORMAL

