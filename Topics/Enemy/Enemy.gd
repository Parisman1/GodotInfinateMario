extends Area2D



var on_floor:bool = false

func init(spawn):
	global_position = Vector2(spawn.x, spawn.y)


#when hit, send signal to die
func _on_Area2D_area_entered(area):
	if area != Area2D:
		area.get_parent().Die()

func Die():
	self.queue_free()
