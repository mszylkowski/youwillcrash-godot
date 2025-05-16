extends Node

var value := 0:
	set(v):
		value = v
		currency_changed.emit(value)

signal currency_changed(value: int)

## Increases the currency, such as picking up items.
func increase(delta: int) -> void:
	value += delta

## Decreases the currency, such as buying items. If not enough, returns false.
func decrease(delta: int) -> bool:
	if value >= delta:
		value -= delta
		return true
	return false
