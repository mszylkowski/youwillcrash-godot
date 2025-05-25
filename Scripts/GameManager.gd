class_name GameManager extends Node2D

@export var score_text: Label
@export var level_text: Label
@export var play_text: Label

const CURRENCY_OBJECT := preload("res://Obstacles/Currency.tscn")

var playing := false
var level := 1:
	set(l):
		level = l
		if level_text:
			level_text.text = str(level)
		level_data = Level.from_number(level)
var level_data: Level

var score := 0.0:
	set(s):
		score = s
		if score_text:
			score_text.text = str(floori(score))
		Events.score_change.emit(score)

var spawn_debt := 0.0
var last_picked_currency_time := 0.0

func _ready() -> void:
	Events.change_state.connect(on_state_change)
	Events.picked_currency.connect(picked_currency)

func _physics_process(delta: float) -> void:
	if not playing:
		return
	score += delta * 10
	level = floori((score / 150.)) + 1
	spawn_debt += delta
	if last_picked_currency_time >= 0:
		last_picked_currency_time += delta
	try_spawning()

func on_state_change(state: Events.GameState) -> void:
	if state == Events.GameState.GAME:
		start_game()
	else:
		end_game()

func try_spawning() -> void:
	if spawn_debt > 0:
		var cost := level_data.spawn_shape(self)
		spawn_debt = -cost
	if last_picked_currency_time > 3:
		var currency := CURRENCY_OBJECT.instantiate() as CurrencyPickup
		add_child(currency)
		last_picked_currency_time = -1

func start_game() -> void:
	if playing:
		return
	level = 1
	score = 0
	playing = true
	spawn_debt = 0
	last_picked_currency_time = 0
	modulate = Color.WHITE

func end_game() -> void:
	if not playing:
		return
	playing = false
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, .5)
	play_text.text = str(floori(score))
	await tween.finished
	for child in get_children():
		child.queue_free()

func picked_currency() -> void:
	score += 10
	last_picked_currency_time = 0
