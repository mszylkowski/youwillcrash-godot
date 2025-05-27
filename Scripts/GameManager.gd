class_name GameManager extends Node2D

@export var play_text: Label

const CURRENCY_OBJECT := preload("res://Obstacles/Currency.tscn")

var playing := false
var level := -1:
	set(l):
		if level == l: return
		level = l
		level_data = Level.from_number(level)
		Events.level_changed.emit(level)
var level_data: Level

var score := 0.0:
	set(s):
		score = s
		Events.score_changed.emit(score)

var spawn_debt := 0.0
var last_picked_currency_time := 0.0

func _ready() -> void:
	Events.state_changed.connect(state_changed)
	Events.picked_currency.connect(picked_currency)
	get_tree().root.size_changed.connect(size_changed)
	size_changed()

func _physics_process(delta: float) -> void:
	if not playing:
		return
	score += delta * 10
	level = floori((score / 150.)) + 1
	spawn_debt += delta
	if last_picked_currency_time >= 0:
		last_picked_currency_time += delta
	try_spawning()

func state_changed(state: GameState.States) -> void:
	if state == GameState.States.GAME:
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
	modulate.a = 1

func end_game() -> void:
	if not playing:
		return
	playing = false
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, .5)
	play_text.text = str(floori(score))
	await tween.finished
	for child in get_children():
		child.queue_free()

func picked_currency() -> void:
	score += 10
	last_picked_currency_time = 0

func size_changed() -> void:
	var scaling: float = get_viewport().size.x / get_viewport_rect().size.x
	material.set("shader_parameter/shadow_offset", Vector2(10, 10) * scaling)
