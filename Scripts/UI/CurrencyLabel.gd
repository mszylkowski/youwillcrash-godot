extends Label

func _ready() -> void:
	Events.currency_changed.connect(on_change)
	pivot_offset = size * .5
	text = str(GameState.currency)

func on_change(value: int) -> void:
	text = str(value)
	Animations.pop(self)
	$"../AudioStreamPlayer2D".play()
