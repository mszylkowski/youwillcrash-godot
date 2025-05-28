class_name Player extends Area2D

@onready var start_pos := global_position
@export var shapes := [] as Array[PlayerShape]

const SCALES_LARGE: Array[float]= [.8, .76, .7]
const SCALES_SMALL: Array[float] = [.08, .06, .04]

var velocity := Vector2.ZERO

func _ready() -> void:
	Events.state_changed.connect(state_changed)
	body_entered.connect(on_collision)
	area_exited.connect(on_collision)
	state_changed(GameState.States.MAIN_MENU)
	shapes[1].top_level = true
	shapes[2].top_level = true

func _physics_process(delta: float) -> void:
	for i in range(shapes.size() - 1):
		shapes[i+1].global_position += (shapes[i].global_position - shapes[i+1].global_position) * clampf(60 * delta, 0, 1)

func state_changed(state: GameState.States) -> void:
	match state:
		GameState.States.GAME:
			%SwipeController.process_mode = Node.PROCESS_MODE_INHERIT
			set_sizes(SCALES_SMALL)
			set_deferred("monitoring", true)
		GameState.States.MAIN_MENU:
			%SwipeController.process_mode = Node.PROCESS_MODE_DISABLED
			set_sizes(SCALES_LARGE)
			set_deferred("monitoring", false)

func on_collision(other: Node2D) -> void:
	if other.is_in_group("currency"):
		(other as CurrencyPickup).pickup()
		return
	GameState.state = GameState.States.MAIN_MENU

	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "global_position", start_pos, .5)

func set_sizes(scales: Array[float]) -> void:
	for i in [2, 1, 0]:
		shapes[i].set_size(scales[i])
		await get_tree().create_timer(.03).timeout
