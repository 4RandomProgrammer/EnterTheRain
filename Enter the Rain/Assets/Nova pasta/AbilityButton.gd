extends TextureButton

onready var time_label = $Counter/Value

export var cooldown = 1.0

var can_use = true

func _ready():
	time_label.hide()
	$Sweep.value = 0
	$Sweep.texture_progress = texture_normal
	$Timer.wait_time = cooldown
	set_process(false)


func _process(_delta):
	on_key_pressed()
	time_label.text = "%3.1f" % $Timer.time_left
	$Sweep.value = int(($Timer.time_left / cooldown) * 100)


func on_key_pressed():
	if Input.is_action_pressed("PowerUp1") and can_use:
		disabled = true
		set_process(true)
		$Timer.start()
		time_label.show()
		can_use = false

func _on_Timer_timeout():
	print("ability ready")
	$Sweep.value = 0
	disabled = false
	time_label.hide()
	set_process(false)
	can_use = true

func _on_AbilityButton_pressed():
	disabled = true
	set_process(true)
	$Timer.start()
	time_label.show()
