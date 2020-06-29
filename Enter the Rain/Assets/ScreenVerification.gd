extends VisibilityNotifier2D

var is_on_screen = false

func _on_VisibilityNotifier2D_screen_entered():
	is_on_screen = true

func _on_VisibilityNotifier2D_screen_exited():
	is_on_screen = false
