class_name TriangleSpiralBoss extends Node2D

const V_OBSTACLE := preload("res://Obstacles/V.tscn") as PackedScene
const ALL_DIRECTIONS: Array[PerpendicularObstacle.Directions] = [
	PerpendicularObstacle.Directions.UP,
	PerpendicularObstacle.Directions.DOWN
]
const INITIAL_DIRECTIONS: Array[PerpendicularObstacle.Directions] = [
	PerpendicularObstacle.Directions.UP,
	PerpendicularObstacle.Directions.DOWN
]

var game_manager: GameManager
var direction: PerpendicularObstacle.Directions

func _ready() -> void:
	game_manager = get_parent()
	assert(game_manager, "V Shower boss could not find parent on _ready")
	direction = INITIAL_DIRECTIONS.pick_random()
	Events.level_changed.connect(queue_free.unbind(1), Object.ConnectFlags.CONNECT_ONE_SHOT)

func _physics_process(_delta: float) -> void:
	if not game_manager or game_manager.spawn_debt <= 0: return

	if game_manager.spawn_debt > 0:
		var shape := V_OBSTACLE.instantiate() as PerpendicularObstacle
		shape.speed *= randf_range(1, 1.5)
		if direction != PerpendicularObstacle.Directions.NONE:
			shape.force_spawn_direction = direction
		else:
			shape.force_spawn_direction = ALL_DIRECTIONS.pick_random()
		game_manager.add_child(shape)
		game_manager.spawn_debt -= Level.OBSTACLE_COST[Level.Obstacles.V] * .2
