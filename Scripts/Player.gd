class_name Player extends Area2D

@onready var start_pos := global_position
@export var shapes := [] as Array[PlayerShape]

const SCALES_LARGE: Array[float]= [.8, .76, .7]
const SCALES_SMALL: Array[float] = [.08, .06, .04]

var velocity := Vector2.ZERO

func _ready() -> void:
	Events.change_state.connect(on_state_change)
	on_state_change(Events.GameState.MAIN_MENU)
	body_entered.connect(on_collision)
	area_exited.connect(print.bind("exited"))

func _process(_delta: float) -> void:
	velocity *= _delta * 5
	for i in shapes.size():
		shapes[i].position = velocity * i

func on_state_change(state: Events.GameState) -> void:
	match state:
		Events.GameState.GAME:
			%SwipeController.process_mode = Node.PROCESS_MODE_INHERIT
			set_sizes(SCALES_SMALL)
		Events.GameState.MAIN_MENU:
			%SwipeController.process_mode = Node.PROCESS_MODE_DISABLED
			set_sizes(SCALES_LARGE)

func on_collision(_other: Node2D) -> void:
	Events.died.emit()
	Events.change_state.emit(Events.GameState.MAIN_MENU)

	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "global_position", start_pos, .5)

func set_sizes(scales: Array[float]) -> void:
	for i in [2, 1, 0]:
		shapes[i].set_size(scales[i])
		await get_tree().create_timer(.03).timeout

func set_velocity(vel: Vector2) -> void:
	velocity = vel
