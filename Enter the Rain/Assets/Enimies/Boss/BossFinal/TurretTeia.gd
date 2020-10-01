extends 'res://Assets/Enimies/Boss/BossFinal/TurretBossFinal.gd'
# Torre da esquerda.

onready var Cobweb_bullet = load("res://Assets/Enimies/Enemy_bullet/Cobweb_bullet.tscn")

func _ready():
	randomize()
	velocity = Vector2(0, 1)  # Iniciar vetor movimento para baixo.

func _on_Timer_spawn_timeout():
	state = NORMAL
	$Timer_change_dir.start(rand_range(3, 15))
	$Timer_pow1.start(rand_range(5, 12))


func _on_Timer_pow1_timeout():
	var extra_angle = - PI / 3
	while extra_angle < PI / 3:
		print('oi')
		var cobweb_bullet = Cobweb_bullet.instance()
		cobweb_bullet.start(global_position, rotation + extra_angle)
		get_parent().get_parent().call_deferred('add_child', cobweb_bullet)
		extra_angle += PI / 12
	$Timer_pow1.start(rand_range(5, 12))
