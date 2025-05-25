class_name CurrencyPickup extends Node2D

const FINAL_POS := Vector2(-47, -430)

@onready var sprite := $Sprite2D as Sprite2D

@export var offset_x := 200
@export var offset_y := 350

func _ready() -> void:
	global_position = Vector2(randf_range(-offset_x, offset_x), randf_range(-offset_y, offset_y))

	var final_scale := sprite.scale
	sprite.scale = Vector2.ZERO
	var tween := sprite.get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(sprite, "scale", final_scale, .4)

func pickup() -> void:
	GameState.increase_currency(1)
	$CollisionShape2D.set_deferred("disabled", true)
	Events.picked_currency.emit()
	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "global_position", FINAL_POS, .4)
	await tween.finished
	queue_free()
