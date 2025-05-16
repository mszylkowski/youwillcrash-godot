class_name SwipeController extends Node

@onready var player := get_parent() as Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		print(event)
