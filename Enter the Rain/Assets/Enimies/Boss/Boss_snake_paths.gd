extends Path2D

onready var path_1 = load('res://Assets/Enimies/Boss/Boss_Snake_path.tres')
onready var path_2 = load('res://Assets/Enimies/Boss/Boss_Snake_path_3.tres')
onready var path_list = [path_1, path_2]

func _ready():
	path_list.shuffle()
	get_node('.').curve = path_list[0]

