extends "res://Assets/Player/Character.gd"

var OldMax_Speed
onready var RunTimer = $RunTimer

func estado_base(delta):
	movement_loop(delta)
	control_loop()
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	
	if Input.is_action_pressed("Shoot"):
		pass
	
	elif Input.is_action_just_pressed("PowerUp1"):
		pass
		
	elif Input.is_action_just_pressed("PowerUp2"):
		pass

func roll_state():
	pass
	
func _on_HurtBox_area_entered(_area):
	pass # Replace with function body.
