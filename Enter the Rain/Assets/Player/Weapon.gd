extends Sprite

func _physics_process(delta):
	look_at(get_global_mouse_position())
	
