## Holds static functions that animate UI elements.
class_name Animations extends Node

## Fades in while scaling up a UI element.
static func animate_in(node: CanvasItem) -> Tween:
	node.scale = Vector2(.8, .8)
	var tween := node.get_tree().create_tween().set_parallel(true)
	tween.tween_property(node, "modulate:a", 1, .1).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(node, "scale", Vector2(1, 1), .3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	return tween

## Fades out while scaling up a UI element.
static func animate_out(node: CanvasItem) -> Tween:
	var tween := node.get_tree().create_tween().set_parallel(true)
	tween.tween_property(node, "modulate:a", 0, .3).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(node, "scale", Vector2(1.3, 1.3), .3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	return tween

## Pops in place a UI element.
static func pop(node: CanvasItem) -> Tween:
	var tween := node.get_tree().create_tween()
	tween.tween_property(node, "scale", Vector2(.5, .5), .05).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(node, "scale", Vector2(1, 1), .5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	return tween
