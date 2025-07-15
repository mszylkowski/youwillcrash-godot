class_name SnakeDenBoss extends Node2D

const SNAKE_OBSTACLE := preload("res://Obstacles/Snake.tscn") as PackedScene

var game_manager: GameManager

func _ready() -> void:
	game_manager = get_parent()
	assert(game_manager, "Snake den boss could not find parent on _ready")

func _physics_process(_delta: float) -> void:
	if not game_manager or game_manager.spawn_debt <= 0: return

	if game_manager.spawn_debt > 0:
		var shape := SNAKE_OBSTACLE.instantiate() as SnakeObstacle
		shape.force_length = randi_range(12, 16)
		shape.hue_shift_style = SnakeObstacle.HueShiftMode.PER_PART
		game_manager.add_child(shape)
		game_manager.spawn_debt -= Level.OBSTACLE_COST[Level.Obstacles.SNAKE] * .5
