extends Label

func _ready() -> void:
	Events.currency_changed.connect(on_change)
	pivot_offset = size * .5
	text = str(GameState.currency)

func on_change(value: int) -> void:
	text = str(value)
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", Vector2(.5, .5), .1)
	tween.tween_property(self, "scale", Vector2(1, 1), .3)
	$"../AudioStreamPlayer2D".play()
