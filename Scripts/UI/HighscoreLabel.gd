extends Label

func _ready() -> void:
	Events.died.connect(update)
	Events.mode_changed.connect(update.unbind(1))
	update()

func update() -> void:
	text = "BEST: " + str(GameState.highscores.get_or_add(GameState.mode, 0))
