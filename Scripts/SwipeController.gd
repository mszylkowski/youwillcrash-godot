class_name SwipeController extends Node

@onready var player := get_parent() as Player

func _unhandled_input(event: InputEvent) -> void:
	var motion_event := event as InputEventMouseMotion
	if motion_event and motion_event.pressure > 0.:
		player.global_position += motion_event.relative
		player.set_velocity(motion_event.relative)
