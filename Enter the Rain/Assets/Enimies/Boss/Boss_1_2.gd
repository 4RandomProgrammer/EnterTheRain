extends KinematicBody2D
var velocity = Vector2(175, 0)
var damage = 1
var angle = 90
var slowing = false
var velocity_snake_mov = Vector2.ZERO
var change_dir = false
enum {
	SPAWNING,
	WALKING
}
var state = SPAWNING

signal Spawning
signal Died
signal healthChanged

func _ready():
	var bossHealthBar = get_parent().get_node('Player').get_node('Camera2D').get_node('CanvasLayer').get_node('HealthBarBoss')
	var boss_1_2 = get_node('.')
	boss_1_2 = get_node('.')
	boss_1_2.connect("Spawning", bossHealthBar, "_on_Boss_Spawning")
	boss_1_2.connect("Died", bossHealthBar, "_on_Boss_Died")
	boss_1_2.connect("healthChanged", bossHealthBar, "_on_Boss_healthChanged")
	emit_signal("Spawning", $Stats.MaxHealth)

func _physics_process(delta):
	match state:
		SPAWNING:
			pass
		WALKING:
			movimentation(delta)


func movimentation(delta):
	var colision = move_and_collide(velocity * delta)  # mov padrao
	if slowing:
		velocity_snake_mov -= velocity * 0.02
	else:
		velocity_snake_mov += velocity * 0.02
	move_and_collide(velocity_snake_mov.rotated(angle) * delta)  # mov para baixo e para cima (que nem cobra).

func _on_Timer_mov_timeout():
	velocity_snake_mov = Vector2.ZERO
	if change_dir:
		angle = 90
		change_dir = false
	else:
		angle = -90
		change_dir = true


func _on_Timer_parar_timeout():
	if slowing:
		slowing = false
	else:
		slowing = true


func _on_Timer_spawn_timeout():
	$Timer_mov.start()
	$Timer_parar.start()
	state = WALKING


func _on_HurtBox_area_entered(area):
	if state != SPAWNING:
		var damage_taken = area.DAMAGE
		$Stats.Health -= damage_taken
		emit_signal('healthChanged', $Stats.Health)


func _on_Stats_no_health():
	emit_signal('Died')
	queue_free()
