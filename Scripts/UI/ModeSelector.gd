class_name ModeSelector extends Panel

@export var modes_order: Array[GameState.Modes] = [
	GameState.Modes.CLASSIC,
	GameState.Modes.SNAKE_DEN,
	GameState.Modes.FIREWORKS_SHOW,
	GameState.Modes.FIREWORK_HELL,
	GameState.Modes.ALL_BOSSES,
	GameState.Modes.RED_SHOWER
]

@onready var scroller := %ScrollContainer as ScrollContainer
@onready var hbox := %HBoxContainer as HBoxContainer
@onready var mode_squares := hbox.get_children() as Array[Node]
@onready var square_size := mode_squares[0].size as Vector2
@onready var square_sep := (hbox.size.x - square_size.x * mode_squares.size()) / (mode_squares.size() - 1)

var pos_tween: Tween
var target_pos := 0.

func _ready() -> void:
	%Exit.pressed.connect(slide_out)

func slide_in() -> void:
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "global_position:y", -286, .5)
	Events.change_border.emit(Border.MENU_SIZE, Border.MENU_RADIUS)

func slide_out() -> void:
	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "global_position:y", 800, .5)
	Events.change_border.emit(Border.GAME_SIZE, Border.GAME_RADIUS)

func _process(_delta: float) -> void:
	var pos := scroller.scroll_horizontal
	var item_size: float = square_size.x + square_sep
	for i in range(mode_squares.size()):
		var dist: float = clampf(abs(pos / item_size - i), 0.1, 1.1) - .1
		var s := 1. / (dist * 1.25 + 1.)
		mode_squares[i].scale = Vector2(s, s)
		mode_squares[i].pivot_offset = square_size * .5


func _on_scroll_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_pressed():
		_scroll_wheel(square_size.x + square_sep)
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_pressed():
		_scroll_wheel(-square_size.x - square_sep)
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
		print("released ", event)
	elif event is InputEventMouseMotion and (event.button_mask & MOUSE_BUTTON_MASK_LEFT):
		scroller.scroll_horizontal -= roundi((event as InputEventMouseMotion).screen_relative.x)
	elif event is InputEventScreenDrag:
		get_viewport().set_input_as_handled()

func _scroll_wheel(delta: float) -> void:
	if pos_tween and pos_tween.is_running():
		pos_tween.kill()
	target_pos = clampf(target_pos + delta, 0, scroller.get_child(0).size.x - scroller.size.x)
	pos_tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	pos_tween.tween_property(scroller, "scroll_horizontal", target_pos, .3)
