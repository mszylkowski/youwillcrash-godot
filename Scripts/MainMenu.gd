extends Node2D

@onready var animation := %AnimationPlayer as AnimationPlayer

var showing := true

func _ready() -> void:
	%PlayButton.input_event.connect(_handle_play_click)
	Events.died.connect(toggle.bind(true))

func toggle(value: bool) -> void:
	if showing == value:
		return
	showing = value
	animation.play("hide", -1, -1 if value else 1)

func _handle_play_click(_v: Viewport, event: InputEvent, _s: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if showing:
			toggle(false)
