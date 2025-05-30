class_name ModeSelector extends Panel

@export var button_mapping: Dictionary[CheckButton, GameState.Modes] = {}

func _ready() -> void:
	%Exit.pressed.connect(slide_out)
	for button: CheckButton in button_mapping.keys():
		var mode := button_mapping.get(button) as GameState.Modes
		button.pressed.connect(Events.mode_changed.emit.bind(mode))

func slide_in() -> void:
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "global_position:y", -286, .5)

func slide_out() -> void:
	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "global_position:y", 800, .5)
