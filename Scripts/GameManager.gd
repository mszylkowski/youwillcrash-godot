class_name GameManager extends Node2D

@export var play_text: Label

const CURRENCY_OBJECT := preload("res://Obstacles/Currency.tscn")
const NEXT_LEVEL_SOUND := preload("res://Audio/Stage.ogg")

var playing := false
var level_factory := LevelFactory.classic
var level := -1:
	set(l):
		if level == l: return
		level = l
		if level == -1:
			level_data = null
		else:
			level_data = level_factory.call(level)
		Events.level_changed.emit(level)
static var level_data: Level

var score := 0.0:
	set(s):
		score = s
		Events.score_changed.emit(score)

var spawn_debt := 0.0
var last_picked_currency_time := 0.0
var current_boss: Node2D

func _ready() -> void:
	Events.state_changed.connect(state_changed)
	Events.picked_currency.connect(picked_currency)
	Events.level_changed.connect(level_changed.unbind(1))
	Events.mode_changed.connect(mode_changed)
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
	if not level_data.is_boss and spawn_debt > 0:
		level_data.spawn_shape(self)
	if last_picked_currency_time > 3:
		var currency := CURRENCY_OBJECT.instantiate() as CurrencyPickup
		add_child(currency)
		last_picked_currency_time = -1

func start_game() -> void:
	if playing: return
	level = 1
	score = 0
	playing = true
	spawn_debt = 0
	last_picked_currency_time = 0
	material.set("shader_parameter/alpha", 1.)

func end_game() -> void:
	if not playing: return
	playing = false
	var tween := get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(material, "shader_parameter/alpha", 0., .5)
	play_text.text = str(floori(score))
	level = -1
	current_boss = null
	await tween.finished
	for child in get_children():
		child.queue_free()

func picked_currency() -> void:
	score += 10
	last_picked_currency_time = 0

func size_changed() -> void:
	var scaling: float = get_viewport().size.x / get_viewport_rect().size.x
	material.set("shader_parameter/shadow_offset", Vector2(10, 10) * scaling)

func level_changed() -> void:
	if level > 1:
		Audios.play_sound(NEXT_LEVEL_SOUND).volume_linear = .4
	if current_boss:
		current_boss.queue_free()
	if level_data and level_data.is_boss:
		current_boss = level_data.spawn_shape(self)

func mode_changed(mode: GameState.Modes) -> void:
	match mode:
		GameState.Modes.CLASSIC:
			level_factory = LevelFactory.classic
		GameState.Modes.SNAKE_DEN:
			level_factory = LevelFactory.snake_den
		GameState.Modes.FIREWORKS_SHOW:
			level_factory = LevelFactory.firework_show
		GameState.Modes.FIREWORK_HELL:
			level_factory = LevelFactory.firework_hell
		GameState.Modes.ALL_BOSSES:
			level_factory = LevelFactory.all_bosses
		GameState.Modes.RED_SHOWER:
			level_factory = LevelFactory.red_shower
