extends Node

onready var wastelandLv = $Wasteland/Level
onready var wastelandBoss = $Wasteland/Boss



var Music = null

func stop_music():
	$AnimationPlayer.stop()
	wastelandBoss.stop()
	wastelandLv.stop()
	$Forest/Boss.stop()
	$Forest/Level.stop()
	$City/Level.stop()
	$City/Boss.stop()

func playmusic(whatmusic):
	match whatmusic:
		0:
			$AnimationPlayer.play("WasteStart")
		1:
			$AnimationPlayer.play("WasteLvToBoss")
		2:
			$AnimationPlayer.play("BossWToLvForest")
		3:
			$AnimationPlayer.play("LvForestToBossForest")
		4:
			$AnimationPlayer.play("BossForestToLvCity")
		5:
			$AnimationPlayer.play("LvCityToBossCity")
