extends Node

const STATE_PATH := "user://state.cfg"

var currency := 0:
	set(v):
		currency = v
		Events.currency_changed.emit(currency)

var games_played := 0
var highscore := 0:
	set(h):
		highscore = h
		Events.highscore_changed.emit(highscore)

func _ready() -> void:
	load_state()
	Events.score_change.connect(
		func(score: int) -> void:
			if score > highscore:
				highscore = score
	)
	Events.died.connect(save_state)

## Increases the currency, such as picking up items.
func increase_currency(delta: int) -> void:
	currency += delta

## Decreases the currency, such as buying items. If not enough, returns false.
func decrease_currency(delta: int) -> bool:
	if currency >= delta:
		currency -= delta
		return true
	return false

func save_state() -> void:
	var state := ConfigFile.new()
	state.set_value("game", "currency", currency)
	state.set_value("game", "highscore", highscore)
	state.set_value("game", "games_played", games_played)
	state.save_encrypted(STATE_PATH, make_key())

func make_key() -> PackedByteArray:
	var text := ""
	var start := 79
	for i in range(32):
		start = floori(pow(start, i)) % 128
		text += char(start)
	return text.to_ascii_buffer()

func load_state() -> void:
	var state := ConfigFile.new()
	if FileAccess.file_exists(STATE_PATH):
		state.load_encrypted(STATE_PATH, make_key())
		currency = state.get_value("game", "currency", 0)
		highscore = state.get_value("game", "highscore", 0)
		games_played = state.get_value("game", "games_played", 0)
