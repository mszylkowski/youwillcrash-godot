class_name PlayerShape extends Sprite2D

var tween: Tween

func set_size(s: float, trans := Tween.TRANS_BOUNCE) -> void:
	print("set size", s)
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(trans)
	tween.tween_property(self, "scale", s, .4)
