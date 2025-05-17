class_name SwipeController extends Node

@onready var player := get_parent() as Node2D

func _unhandled_input(event: InputEvent) -> void:
	var motion_event := event as InputEventMouseMotion
	if motion_event and motion_event.pressure > .2:
		player.global_position += motion_event.relative
