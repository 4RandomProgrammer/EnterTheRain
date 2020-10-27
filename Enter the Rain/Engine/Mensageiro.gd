extends Node

onready var wastelandLv = $Wasteland/Level
onready var wastelandBoss = $Wasteland/Boss
onready var tweenOut = $TweenOut
onready var tweenIn = $TweenIn

export var transition_duration = 1.00
export var transition_type = 1 # TRANS_SINE

var Music = null

func playmusic(whatmusic):
	if Music != null:
		fade_out(Music)
	
	match whatmusic:
		0:
			Music = wastelandLv
			Music.play()

			
		1:
			Music = wastelandBoss

func fade_out(stream_player):
	# tween music volume down to 0
	tweenOut.interpolate_property(stream_player, "volume_db", 0, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	tweenOut.start()
	# when the tween ends, the music will be stopped
	
func fade_in(stream_player):
	# tween music volume up to 0
	tweenOut.interpolate_property(stream_player, "volume_db", -80, 0, transition_duration, transition_type, Tween.EASE_IN, 0)
	tweenOut.start()
	# when the tween ends, the music will be stopped

func _on_TweenOut_tween_completed(object, key):
	# stop the music -- otherwise it continues to run at silent volume
	object.stop()


func _on_TweenIn_tween_completed(object, key):
	object.play()
