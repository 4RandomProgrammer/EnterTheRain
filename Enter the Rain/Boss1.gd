extends KinematicBody2D

onready var velocidade = 100
onready var direcoes = [Vector2(velocidade, velocidade), Vector2(- velocidade, - velocidade),
						Vector2(- velocidade, velocidade), Vector2(velocidade, - velocidade)]
onready var timer_parar = $Timer_parar
onready var timer_andar = $Timer_andar
var movimento = Vector2.ZERO
enum {
	PARADO
	ANDANDO
}
var estado = ANDANDO


func _ready():
	velocidade = direcoes[0]


func _physics_process(delta):
	match estado:
		ANDANDO:
			var space_state = get_world_2d().direct_space_state
			var colisao = move_and_collide(velocidade * delta)
			if colisao:
				print('BATEU')
				velocidade = velocidade.bounce(colisao.normal)
		PARADO:
			pass


func _on_Timer_parar_timeout():
	print('Hora de parar')
	timer_andar.start(5)
	estado = PARADO
	

func _on_Timer_andar_timeout():
	print('Hora de andar')
	timer_andar.start(10)
	estado = ANDANDO
