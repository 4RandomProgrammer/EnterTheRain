extends Control

onready var Health_bar = $TextureProgress
onready var UpdateTween = $Tween
onready var Heal_bar2 = $TextureProgress2


func _on_Boss_healthChanged(health):
	Health_bar.value = health
	UpdateTween.interpolate_property(Heal_bar2,"value", Heal_bar2.value,health,0.4,Tween.TRANS_SINE,Tween.EASE_IN_OUT,0.4)
	UpdateTween.start()


func _on_Boss_Spawning(maxHealth):
	print('oi')
	Health_bar.max_value = maxHealth
	Health_bar.value = maxHealth
	Heal_bar2.max_value = maxHealth
	Heal_bar2.value = maxHealth
	visible = true

func _on_Boss_Died():
	visible = false
