extends Label

func _ready() -> void:
	text = str(Currency.value)
	Currency.currency_changed.connect(
		func(value: int)->void:
			text = str(value)
	)
