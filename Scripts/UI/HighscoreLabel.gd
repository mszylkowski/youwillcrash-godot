extends Label

func _ready() -> void:
	text = "BEST: " + str(GameState.highscore)
	Events.died.connect(
		func() -> void:
			text = "BEST: " + str(GameState.highscore)
	)
