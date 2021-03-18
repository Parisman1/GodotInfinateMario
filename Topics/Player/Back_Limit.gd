extends Area2D



func _on_Back_Limit_area_entered(area):
	print("TEST: ", area.get_parent())
