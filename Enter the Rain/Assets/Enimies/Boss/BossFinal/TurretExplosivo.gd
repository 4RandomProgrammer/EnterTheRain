extends 'res://Assets/Enimies/Boss/BossFinal/TurretBossFinal.gd'
# Torre de baixo.

onready var Super_explosive_bul = load("res://Assets/Enimies/Enemy_bullet/SuperExplosiveBullet.tscn")

func _ready():
	randomize()
	velocity = Vector2(1, 0)  # Começar movendo para a direita

func _on_Timer_spawn_timeout():
	state = NORMAL
	$Timer_change_dir.start(rand_range(3, 15))
	$Timer_pow1.start(rand_range(5, 12))

func _on_Timer_pow1_timeout():
	var super_explosive_bul = Super_explosive_bul.instance()
	super_explosive_bul.start(global_position, rotation)
	get_parent().get_parent().call_deferred('add_child', super_explosive_bul)
	$Timer_pow1.start(rand_range(5, 12))
