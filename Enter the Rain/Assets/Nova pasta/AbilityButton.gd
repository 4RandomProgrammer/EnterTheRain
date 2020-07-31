extends TextureButton

onready var time_label = $Counter/Value

export var cooldown = 1.0

var can_use = true

func _ready():
	time_label.hide()
	$Sweep.value = 0
	$Sweep.texture_progress = texture_normal
	$Timer.wait_time = cooldown


func _process(_delta):
	time_label.text = "%3.1f" % $Timer.time_left
	$Sweep.value = int(($Timer.time_left / cooldown) * 100)


func _on_Timer_timeout():
	print("ability 1 ready")
	$Sweep.value = 0
	disabled = false
	time_label.hide()
	_process(false)



func _on_Player_PW1_used():
	disabled = true
	set_process(true)
	$Timer.start()
	time_label.show()
	can_use = false
