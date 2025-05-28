extends Node2D

func _ready() -> void:
	hide_all()
	Events.state_changed.connect(state_changed)

func state_changed(state: GameState.States):
	if state != GameState.States.GAME:
		if visible:
			await Animations.animate_out(self).finished
			visible = false
		return
	for child: Label in get_children():
		child.pivot_offset = child.size * .5
		child.modulate.a = 0
	scale = Vector2.ONE
	modulate.a = 1

	await get_tree().create_timer(.7).timeout
	if _should_cancel(): return

	visible = true
	for child: Label in get_children():
		await Animations.animate_in(child).finished
		if _should_cancel(): return

	await get_tree().create_timer(.3).timeout

	for child: Label in get_children():
		await Animations.animate_out(child).finished
		if _should_cancel(): return

	Events.intro_finished.emit()
	hide_all()

func hide_all() -> void:
	for child: Label in get_children():
		child.modulate.a = 0

func _should_cancel() -> bool:
	return GameState.state != GameState.States.GAME
