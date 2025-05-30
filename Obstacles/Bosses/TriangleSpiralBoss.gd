extends Node2D

const TRIANGLE_OBSTACLE := preload("res://Obstacles/Triangle.tscn") as PackedScene
const CHANGE_DIRECTION_COST := Level.OBSTACLE_COST[Level.Obstacles.TRIANGLE] * 1.
const SPAWN_TRIANGLE_COST := Level.OBSTACLE_COST[Level.Obstacles.TRIANGLE] * .2

var game_manager: GameManager
var initial_angle := 0.
var change_angle := .4
var remaining_change_count := 0

func _ready() -> void:
	game_manager = get_parent()
	assert(game_manager, "TriangleSpiral could not find parent on _ready")
	initial_angle = randf() * TAU
	remaining_change_count = randi_range(20, 50)
	game_manager.spawn_debt -= CHANGE_DIRECTION_COST * game_manager.level_data.cost_adjustment * 2

func _physics_process(_delta: float) -> void:
	if not game_manager or game_manager.spawn_debt <= 0: return

	if game_manager.spawn_debt > 0:
		var shape := TRIANGLE_OBSTACLE.instantiate() as SimpleObstacle
		shape.speed *= 2
		shape.force_spawn_angle = initial_angle
		shape.deviation = 0
		initial_angle += change_angle
		remaining_change_count -= 1
		if remaining_change_count == 0:
			change_angle *= -1
			remaining_change_count = randi_range(20, 50)
			game_manager.spawn_debt -= CHANGE_DIRECTION_COST * game_manager.level_data.cost_adjustment
		game_manager.add_child(shape)
		game_manager.spawn_debt -= SPAWN_TRIANGLE_COST * game_manager.level_data.cost_adjustment
