class_name ModeSelector extends Panel

var modes_order: Array[GameState.Modes] = [
	GameState.Modes.CLASSIC,
	GameState.Modes.RED_SHOWER,
	GameState.Modes.SNAKE_DEN,
	GameState.Modes.FIREWORKS_SHOW,
	GameState.Modes.FIREWORK_HELL,
	GameState.Modes.PITCH_BLACK,
	GameState.Modes.ALL_BOSSES,
]

static var MODES_NAMES: Array[String] = [
	"Classic", "Red Shower", "Snake Den", "Fireworks Show", "Fireworks Hell", "Pitch Black", "All Bosses"
]

var modes_unlocks: Array[int] = [0, 100, 250, 400, 600, 800, 1000]

@onready var scroller := %ScrollContainer as ScrollContainer
@onready var hbox := %HBoxContainer as HBoxContainer
@onready var mode_squares := hbox.get_children() as Array[Node]
@onready var square_size := mode_squares[0].size as Vector2
@onready var square_sep := (hbox.size.x - square_size.x * mode_squares.size()) / (mode_squares.size() - 1)
@onready var item_size := square_size.x + square_sep

var pos_tween: Tween
var label_tween: Tween
var active := false
var target_pos := 0

func _ready() -> void:
	%Exit.pressed.connect(slide_out)
	Events.currency_changed.connect(update_unlocks)
	update_unlocks(GameState.currency)

func slide_in() -> void:
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "global_position:y", -300, .25)
	Events.change_border.emit(Border.MENU_SIZE, Border.MENU_RADIUS)
	Audios.play_ui_sound()
	active = true

func slide_out() -> void:
	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "global_position:y", 800, .25)
	Events.change_border.emit(Border.GAME_SIZE, Border.GAME_RADIUS)
	Audios.play_ui_sound()
	active = false

func _process(_delta: float) -> void:
	if not active:
		return
	var pos := scroller.scroll_horizontal
	for i in range(mode_squares.size()):
		var dist: float = clampf(abs(pos / item_size - i), 0.1, 1.1) - .1
		var s := 1. / (dist * 1.25 + 1.)
		mode_squares[i].scale = Vector2(s, s)
		mode_squares[i].pivot_offset = square_size * .5

func _on_scroll_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_RIGHT] and event.is_pressed():
		if not pos_tween or not pos_tween.is_running(): _scroll_wheel(1)
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton and event.button_index in [MOUSE_BUTTON_WHEEL_DOWN, MOUSE_BUTTON_WHEEL_LEFT] and event.is_pressed():
		if not pos_tween or not pos_tween.is_running(): _scroll_wheel(-1)
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
		var target_idx := roundi(scroller.scroll_horizontal / item_size)
		_scroll_to(target_idx)
	elif event is InputEventMouseMotion and (event.button_mask & MOUSE_BUTTON_MASK_LEFT):
		scroller.scroll_horizontal -= roundi((event as InputEventMouseMotion).relative.x)
		var curr_idx := roundi(scroller.scroll_horizontal / item_size)
		if target_pos != curr_idx:
			target_pos = curr_idx
			set_curr_mode(curr_idx)
	elif event is InputEventScreenDrag:
		get_viewport().set_input_as_handled()

func _scroll_wheel(delta: int) -> void:
	_scroll_to(target_pos + delta)

func update_unlocks(_curr: int) -> void:
	for i in range(mode_squares.size()):
		var label: Label = mode_squares[i].get_child(0)
		var can_use := GameState.currency >= modes_unlocks[i]
		label.visible = not can_use
		mode_squares[i].self_modulate = Color.WHITE if can_use else Color.DIM_GRAY
		if not can_use:
			label.text = "Unlocks after\n%d points" % modes_unlocks[i]


func _scroll_to(idx: int) -> void:
	if pos_tween and pos_tween.is_running():
		pos_tween.kill()
	var changed := target_pos != idx
	target_pos = clampi(idx, 0, mode_squares.size() - 1)
	pos_tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	pos_tween.tween_property(scroller, "scroll_horizontal", target_pos * item_size, .3)
	if changed:
		set_curr_mode(target_pos)

func set_curr_mode(idx: int) -> void:
	%CurrMode.text = MODES_NAMES[idx]
	if GameState.currency <= modes_unlocks[idx]:
		%Exit.disabled = true
		%Exit.self_modulate = Color(1, 1, 1, .5)
		return
	%Exit.disabled = false
	%Exit.self_modulate = Color.WHITE
	GameState.mode = modes_order[idx]
	if label_tween and label_tween.is_running():
		label_tween.kill()
	%CurrMode.pivot_offset = %CurrMode.size * .5
	label_tween = Animations.pop(%CurrMode)
	Audios.play_ui_sound_small()
