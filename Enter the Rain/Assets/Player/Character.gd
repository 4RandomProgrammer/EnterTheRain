extends KinematicBody2D

enum {
	MOVE,
	ROLL,
	PW1,
	PW2,
	KNOCKBACK
}

export(int) var  MaxHealth = 1
export (int) var MAX_SPEED = 250
var current_speed = 250
export (float)var fire_rate = 0.5
export (float)var cooldownP1 = 2
export (float)var cooldownP2 = 3
onready var InvunerabilityTimer = $HurtBox/Timer
onready var hurtbox = $HurtBox
var Health
var posAnt = Vector2.RIGHT
export var stun_probability = 0
export var extra_shots_probability = 0
export var missile_probability = 0
var MISSILE_SHOT = load("res://Assets/Shot/MissileBullet.tscn")
export var health_drop_probability = 0
var roll_vector = Vector2.DOWN
var Mouse = Vector2.ZERO
var state = MOVE
var Can_PowerUp1 = true
var Can_PowerUp2 = true
var can_fire = true
var shot_damage_modifier = 1
var skill_damage_modifier = 1
var dano = 0
var moveDirection = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var quant_poison = 0
var timer_poison = 0
var money = 0

const FRICTION = 25
const SHOT = preload("res://Assets/Shot/Shot.tscn")
onready var health_item = load("res://Assets/Itens/Item_life_regen.tscn")

#Sinais
signal healthChanged(health)
signal maxhealthChanged(value)
signal set_maxhealth(value)
signal no_health
signal moneyChanged(current_money)
signal poisonChanged
signal PW1_used
signal PW2_used

func _ready():
	rng.randomize()
	Health = MaxHealth
	emit_signal("set_maxhealth",Health)

func _physics_process(delta):
	poison_verifications(delta)
	#Maquina de estados
	match state:
		MOVE:
			estado_base(delta)

		ROLL:
			roll_state()

func roll_state():
	pass

func estado_base(_delta):
	pass

func poison_verifications(delta):
	emit_signal("poisonChanged", timer_poison)
	if quant_poison > 0:  # O player está em uma poça de veneno. O timer deve aumentar
		timer_poison += 1 * delta
		if timer_poison > 1:  # Quando o timer chegar em 1, dar dano ao player
			timer_poison = 0
			set_NewHealth(-1)
	elif timer_poison > 0:  # O player não está em nehuma poça de veneno, diminuir o timer...
		timer_poison -= 1 * delta


func set_MaxHealth(value):
	MaxHealth += value
	emit_signal("maxhealthChanged", value)

func set_NewHealth(value):
	Health += value
	emit_signal("healthChanged", Health)
	if Health <= 0:
		emit_signal("no_health")
		die()

#Func de tiro
func shot(isStunBullet):
	var space_state = get_world_2d().direct_space_state
	var colision = space_state.intersect_ray(global_position, $Weapon/Position2D.global_position, [self], collision_mask)
	if not colision:  # Só atirar se não tiver nenhuma parede na frente.
		var shots = SHOT.instance()
		shots.stunbullet = isStunBullet
		if not isStunBullet:  # O tiro atual é um tiro comum
			if rng.randi_range(1, 100) <= stun_probability:
				shots.stunbullet = true
			if rng.randi_range(1, 100) <= extra_shots_probability:
				extra_shots()
			if rng.randi_range(1, 100) <= missile_probability:
				missile()
		shots.damage = shot_damage_modifier * (shots.damage + dano)
		get_parent().add_child(shots)
		shots.position = $Weapon/Position2D.global_position
		shots.rotation_degrees = $Weapon.rotation_degrees
		shots.apply_impulse(Vector2(), Vector2(shots.BULLET_SPEED, 0).rotated($Weapon.rotation))

func extra_shots():
	for angle in [PI / 6, -PI / 6]:
		var extra_shot = SHOT.instance()
		extra_shot.position = $Weapon/Position2D.global_position
		extra_shot.rotation = $Weapon.rotation_degrees + angle
		extra_shot.apply_impulse(Vector2(), Vector2(extra_shot.BULLET_SPEED, 0).rotated($Weapon.rotation + angle))
		get_parent().add_child(extra_shot)

func missile():
	var missile = MISSILE_SHOT.instance()
	missile.start(global_position, $Weapon.rotation)
	get_parent().add_child(missile)


func die():
	queue_free()

#Func de inputs
func control_loop():
	#Passando o movimento direto com a anulação de tecla ja feita
	moveDirection.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	moveDirection.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

#Func de movimento, aqui se adiciona knockback se quiser
func movement_loop(delta):
	if moveDirection != Vector2.ZERO:
		moveDirection += moveDirection.normalized() * current_speed
		roll_vector = moveDirection.normalized()
	else:
		moveDirection = moveDirection.move_toward(Vector2.ZERO, FRICTION * delta)
	move()

func move():
	moveDirection = move_and_slide(moveDirection)

func apply_buff(what_buff):
	$Buffs_Controller.cd_changer()


func _on_HurtBox_area_entered(area):
	if InvunerabilityTimer.is_stopped():
		hurtbox.start_invincibility(0.5)
		$AnimationPlayer.play("Flash")
		set_NewHealth(- area.DAMAGE)
		

func update_Money(money_value):
	# Atualiza o dinheiro do player. Acontece ao matar inimigos(ganha dinheiro) e abrir baus(perde).
	money += money_value
	emit_signal("moneyChanged", money)

func player_killed_enemy(enemy_position, min_money, max_money):
	update_Money(rng.randi_range(min_money, max_money))
	if rng.randi_range(1, 100) <= health_drop_probability:
		var health_droped = health_item.instance()
		health_droped.position = enemy_position
		get_parent().add_child(health_droped)


func _on_PowerUp1CD_timeout():
	Can_PowerUp1 = true

func _on_PowerUP2CD_timeout():
	Can_PowerUp2 = true

func _on_ShotCD_timeout():
	can_fire = true
