extends Node2D

func _ready() -> void:
	hide_all()
	Events.state_changed.connect(state_changed)

func state_changed(state: Events.GameState):
	if state != Events.GameState.GAME:
		visible = false
		return
	for child: Label in get_children():
		child.pivot_offset = child.size * .5
		child.modulate.a = 0
	await get_tree().create_timer(.7).timeout

	visible = true
	for child: Label in get_children():
		await Animations.animate_in(child).finished
	await get_tree().create_timer(.3).timeout
	for child: Label in get_children():
		await Animations.animate_out(child).finished

	Events.intro_finished.emit()
	hide_all()

func hide_all() -> void:
	for child: Label in get_children():
		child.modulate.a = 0
