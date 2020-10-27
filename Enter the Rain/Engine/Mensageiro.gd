extends Node

onready var wastelandLv = $Wasteland/Level
onready var wastelandBoss = $Wasteland/Boss



var Music = null

func stop_music():
	$AnimationPlayer.stop()
	wastelandBoss.stop()
	wastelandLv.stop()

func playmusic(whatmusic):
	match whatmusic:
		0:
			$AnimationPlayer.play("WasteStart")
		1:
			$AnimationPlayer.play("WasteLvToBoss")
