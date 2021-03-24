extends Area2D



func _on_Back_Limit_area_entered(area):
	if area.get_name() == 'Enemy':
		area.get_parent().Die()
