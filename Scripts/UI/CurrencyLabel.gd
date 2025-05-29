extends Label

var PICKUP_SOUND := preload("res://Audio/Pickup.ogg")

func _ready() -> void:
	Events.currency_changed.connect(on_change)
	pivot_offset = size * .5
	text = str(GameState.currency)

func on_change(value: int) -> void:
	text = str(value)
	Animations.pop(self)
	Audios.play_sound(PICKUP_SOUND)
