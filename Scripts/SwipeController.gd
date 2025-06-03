class_name SwipeController extends Node

@onready var player := get_parent() as Player

var clicking := false

func _ready() -> void:
	Input.use_accumulated_input = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and (event.button_mask & MOUSE_BUTTON_MASK_LEFT):
		player.global_position += event.relative
		get_viewport().set_input_as_handled()
