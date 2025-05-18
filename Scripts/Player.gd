class_name Player extends PhysicsBody2D

@onready var start_pos := position
@export var shapes := [] as Array[PlayerShape]

const SCALES_LARGE: Array[float]= [.8, .76, .7]
const SCALES_SMALL: Array[float] = [.08, .06, .04]

var velocity := Vector2.ZERO

func _ready() -> void:
	Events.change_state.connect(on_state_change)
	on_state_change(Events.GameState.MAIN_MENU)

func _process(_delta: float) -> void:
	velocity *= .95
	for i in shapes.size():
		shapes[i].position = velocity * i


func on_state_change(state: Events.GameState) -> void:
	print(state)
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

func set_sizes(scales: Array[float]) -> void:
	for i in [2, 1, 0]:
		shapes[i].set_size(scales[i])
		await get_tree().create_timer(.03).timeout

func set_velocity(vel: Vector2) -> void:
	velocity = vel
