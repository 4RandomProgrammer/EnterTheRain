extends KinematicBody2D


onready var Stats = $Stats
enum {
	NORMAL
}
var state = NORMAL
var protected = true

signal Cientista_damaged(health)


func _physics_process(delta):
	update()

func _draw():
	if protected:  # Desenhar escudo se as torres ainda tiverem vivas.
		draw_arc(Vector2.ZERO, 50, 0, 360, 1000, ColorN('Green'))


func _on_HurtBox_area_entered(area):
	if not protected:
		var damage_taken = area.DAMAGE
		Stats.Health -= damage_taken
		emit_signal("Cientista_damaged", Stats.Health)

