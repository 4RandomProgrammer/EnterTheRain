extends Control
onready var poison_bar = $TextureProgress


func _on_Player_poisonChanged(poison):
	poison_bar.value = poison * 100
	if poison <= 0:
		poison_bar.visible = false
	else:
		poison_bar.visible = true
