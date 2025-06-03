extends Node2D

@onready var animation := %AnimationPlayer as AnimationPlayer

var showing := true

func _ready() -> void:
	%PlayButton.input_event.connect(_handle_play_click)
	Events.died.connect(toggle.bind(true))
	Events.score_changed.connect(score_changed)

func toggle(value: bool) -> void:
	if showing == value:
		return
	showing = value
	if value:
		animation.play_backwards("hide")
	else:
		animation.play("hide")

func _handle_play_click(_v: Viewport, event: InputEvent, _s: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and (event.button_mask & MOUSE_BUTTON_MASK_LEFT):
		if showing:
			toggle(false)
			GameState.state = GameState.States.GAME

func score_changed(value: int) -> void:
	if value > 10:
		%PlayLabel.text = str(value)
