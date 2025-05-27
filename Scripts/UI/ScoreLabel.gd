extends Label

func _ready() -> void:
	Events.score_changed.connect(on_change)
	text = "0"

func on_change(value: int) -> void:
	text = str(value)
