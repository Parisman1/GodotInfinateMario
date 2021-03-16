extends Area2D

var generate = false


func _on_Area2D_area_entered(area)->void:
	generate = true
	#print("Nice")
