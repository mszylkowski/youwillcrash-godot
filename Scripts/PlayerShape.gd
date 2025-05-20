class_name PlayerShape extends Node2D

var tween: Tween

func set_size(s: float, trans := Tween.TRANS_BACK) -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(trans)
	tween.tween_property(self, "scale", Vector2(s, s), .5)
