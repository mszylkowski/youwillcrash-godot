class_name SoundToggle extends CheckBox

static var enabled := true

func _ready() -> void:
	toggled.connect(on_toggled)
	button_pressed = enabled

func on_toggled(value: bool) -> void:
	enabled = value
	AudioServer.set_bus_volume_linear(0, 1 if enabled else 0)
	GameState.save_config()
	Audios.play_ui_sound()
