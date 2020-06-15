extends Line2D

export var trail_length = 16
onready var target = get_parent().get_parent()

var point
var stop = false

func _process(_delta):
	if stop:
		remove_point(0)

		if get_point_count() == 0:
			target.queue_free()
	else:
		point = target.global_position
		add_point(point)
		while get_point_count() > trail_length:
			remove_point(0)
