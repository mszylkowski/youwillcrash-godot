class_name Player extends Node2D

@onready var start_pos := position
@export var shapes := [] as Array[PlayerShape]

var SCALES_LARGE: Array[float]= [.8, .76, .7]
var SCALES_SMALL: Array[float] = [.15, .12, .1]

func _ready() -> void:
	Events.change_state.connect(on_state_change)
	on_state_change(Events.GameState.MAIN_MENU)
	
func on_state_change(state: Events.GameState) -> void:
	match state:
		Events.GameState.GAME:
			%SwipeController.process_mode = Node.PROCESS_MODE_INHERIT
			set_sizes(SCALES_SMALL)
		Events.GameState.MAIN_MENU:
			%SwipeController.process_mode = Node.PROCESS_MODE_DISABLED
			set_sizes(SCALES_LARGE)

func on_collision(other: Node2D) -> void:
	Events.died.emit()
	Events.change_state.emit(Events.GameState.MAIN_MENU)

func set_sizes(scales: Array[float]) -> void:
	for i in shapes.size():
		shapes[i].set_size(scales[i])
		await get_tree().create_timer(.1).timeout
			
