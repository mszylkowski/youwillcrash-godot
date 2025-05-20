class_name GameManager extends Node2D

@export var score_text: Label
@export var level_text: Label
@export var play_text: Label

@export var OBSTACLE_V := preload("res://Obstacles/V.tscn")
@export var OBSTACLE_BAR := preload("res://Obstacles/Bar.tscn")

var playing := false
var level := 0:
	set(l):
		level = l
		if level_text:
			level_text.text = str(level)

var score := 0.0:
	set(s):
		score = s
		if score_text:
			score_text.text = str(floori(score))

var spawn_debt := 0.0

func _ready() -> void:
	Events.change_state.connect(on_state_change)

func _physics_process(delta: float) -> void:
	if not playing:
		return
	score += delta * 10
	level = floor((score / 150.) + 1)
	spawn_debt += delta
	try_spawning()
	
func on_state_change(state: Events.GameState) -> void:
	if state == Events.GameState.GAME:
		start_game()
	else:
		end_game()

func try_spawning() -> void:
	if spawn_debt > 1:
		var obstacle := [OBSTACLE_BAR, OBSTACLE_V].pick_random().instantiate() as Node2D
		add_child(obstacle)
		spawn_debt = 0

func start_game() -> void:
	if playing:
		return
	level = 0
	score = 0
	playing = true
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
