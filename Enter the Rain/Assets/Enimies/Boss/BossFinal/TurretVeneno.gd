extends 'res://Assets/Enimies/Boss/BossFinal/TurretBossFinal.gd'
# Torre da direita

var powered = false
onready var Big_bullet = load("res://Assets/Enimies/Enemy_bullet/SlowBigBullet.tscn")
onready var Poison_bullet = load("res://Assets/Enimies/Enemy_bullet/SuperPoisonBullet.tscn")

func _ready():
	randomize()
	velocity = Vector2(0, -1)  # Iniciar vetor movimento para cima.
	
func _on_Timer_spawn_timeout():
	state = NORMAL
	$Timer_change_dir.start(rand_range(3, 15))
	$Timer_pow1.start(rand_range(5, 12))

func _on_Timer_pow1_timeout():
	if not powered:  # Ativar bullets venenosas
		powered = true
		Bullet = Poison_bullet
		bullet_reload_time = 0.6
	else:  # Ativar bullets normais
		powered = false
		Bullet = Big_bullet
		bullet_reload_time = 0.4
	$Timer_pow1.start(rand_range(5, 12))
