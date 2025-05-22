class_name SwipeController extends Node

@onready var player := get_parent() as Player

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion and event.pressure > 0.) or (event is InputEventScreenDrag):
		player.global_position += event.relative
		player.set_velocity(event.relative)
	
