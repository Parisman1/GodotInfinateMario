extends Area2D

var generate = false


func _on_Area2D_area_entered(_area)->void:
	generate = true
