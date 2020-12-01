extends StaticBody2D


onready var rng = RandomNumberGenerator.new()
var player
var percent = 0.5
var choice
var money
var moneyXTimes

func _ready():
	rng.randomize()
	choice = rng.randi() % 3
	money = rng.randi_range(50,200)
	print(money)
	match choice:
		0:
			percent = 0.25
			moneyXTimes = 1
		1:
			percent = 0.5
			moneyXTimes = 2
		2:
			percent = 0.75
			moneyXTimes = 3
	$Label2.text = str(percent*100)

func _process(_delta):
	if player:
		if Input.is_action_just_pressed("ui_select"):
			player.set_NewHealth(-percent * player.MaxHealth)
			player.update_Money(moneyXTimes * money)

func _on_RangeParaAbrir_body_entered(body):
		player = body
		$Label3.visible = true


func _on_RangeParaAbrir_body_exited(_body):
	player = null
	$Label3.visible = false
