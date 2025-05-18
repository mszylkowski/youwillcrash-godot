class_name LevelManager extends Node

func _ready() -> void:
	Events.change_state.connect(on_state_change)

func on_state_change(state: Events.GameState) -> void:
	pass
