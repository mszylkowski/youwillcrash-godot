extends Node2D

func _ready() -> void:
	hide_all()
	Events.change_state.connect(state_changed)

func state_changed(state: Events.GameState):
	if state != Events.GameState.GAME:
		visible = false
		return
	for child: Label in get_children():
		child.pivot_offset = child.size * .5
		child.modulate = Color.TRANSPARENT
		child.scale = Vector2(.8, .8)
	await get_tree().create_timer(.7).timeout

	visible = true
	for child: Label in get_children():
		var tween := child.get_tree().create_tween().set_ease(Tween.EASE_OUT).set_parallel(true)
		tween.tween_property(child, "modulate", Color.WHITE, .1).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(child, "scale", Vector2(1, 1), .5).set_trans(Tween.TRANS_ELASTIC)
		await tween.finished
	await get_tree().create_timer(1.5).timeout
	for child: Label in get_children():
		var tween := child.get_tree().create_tween().set_ease(Tween.EASE_OUT).set_parallel(true)
		tween.tween_property(child, "modulate", Color.TRANSPARENT, .1).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(child, "scale", Vector2(1.3, 1.3), .1).set_trans(Tween.TRANS_QUAD)
		await tween.finished
	hide_all()

func hide_all() -> void:
	for child: Label in get_children():
		child.modulate = Color.TRANSPARENT
