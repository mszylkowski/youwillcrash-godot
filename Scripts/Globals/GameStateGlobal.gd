extends Node

enum States {MAIN_MENU, GAME, SETTINGS, BOOSTS}
enum Modes {CLASSIC, SNAKE_DEN, FIREWORKS_SHOW, FIREWORK_HELL, ALL_BOSSES, RED_SHOWER}

const STATE_PATH := "user://state.cfg"
const SCREEN := Rect2(-240, -450, 480, 900)

var state: States = States.MAIN_MENU: ## Set the state via code directly.
	set(s):
		if state != s: Events.state_changed.emit(s)
		if state == States.GAME and s == States.MAIN_MENU: Events.died.emit()
		state = s

var currency := 0:
	set(v):
		currency = v
		Events.currency_changed.emit(currency)

var games_played := 0
var highscore := 0:
	set(h):
		highscore = h
		Events.highscore_changed.emit(highscore)

var death_causes: Dictionary[String, int] = {}

func _ready() -> void:
	load_config()
	Events.score_changed.connect(
		func(score: int) -> void: if score > highscore: highscore = score
	)
	Events.died.connect(save_config)

## Increases the currency, such as picking up items.
func increase_currency(delta: int) -> void:
	currency += delta

## Decreases the currency, such as buying items. If not enough, returns false.
func decrease_currency(delta: int) -> bool:
	if currency >= delta:
		currency -= delta
		return true
	return false

func register_death_cause(cause: String) -> void:
	death_causes.set(cause, death_causes.get_or_add(cause, 0) + 1)

func save_config() -> void:
	var config := ConfigFile.new()
	config.set_value("game", "currency", currency)
	config.set_value("game", "highscore", highscore)
	config.set_value("game", "games_played", games_played)
	config.set_value("stats", "death_causes", death_causes)
	config.save(STATE_PATH)

func make_key() -> PackedByteArray:
	var text := ""
	var start := 79
	for i in range(32):
		start = floori(pow(start, i)) % 128
		text += char(start)
	return text.to_ascii_buffer()

func load_config() -> void:
	var config := ConfigFile.new()
	if FileAccess.file_exists(STATE_PATH):
		config.load(STATE_PATH)
		currency = config.get_value("game", "currency", 0)
		highscore = config.get_value("game", "highscore", 0)
		games_played = config.get_value("game", "games_played", 0)
		death_causes = config.get_value("stats", "death_causes", {} as Dictionary[String, int])
