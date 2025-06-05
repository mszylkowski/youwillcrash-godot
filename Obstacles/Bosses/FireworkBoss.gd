extends Node2D

const STAR_OBSTACLE := preload("res://Obstacles/Star.tscn") as PackedScene
const SPAWN_STAR_COST := Level.OBSTACLE_COST[Level.Obstacles.STAR] * .2

var game_manager: GameManager
var initial_angle := 0.
var initial_deviation := 0.
var should_rotate := false

func _ready() -> void:
	game_manager = get_parent()
	assert(game_manager, "FireworkBoss could not find parent on _ready")
	initial_angle = [0., 0.11, .2, .3, .7, .8, -.11].pick_random() * TAU
	should_rotate = initial_angle == .11 * TAU or initial_angle == -.11 * TAU # Only rotate if it's not coming from the bottom or top
	match initial_angle:
		.11 * TAU, -.11 * TAU:
			initial_deviation = -initial_angle
		.2 * TAU, .7 * TAU:
			initial_deviation = .05 * TAU
		.3 * TAU, .8 * TAU:
			initial_deviation = -.05 * TAU

func _physics_process(_delta: float) -> void:
	if not game_manager or game_manager.spawn_debt <= 0: return

	if game_manager.spawn_debt > 0:
		var shape := STAR_OBSTACLE.instantiate() as StarObstacle
		shape.force_spawn_angle = initial_angle
		shape.force_spawn_deviation = initial_deviation
		shape.hue_shift_style = StarObstacle.HueShiftMode.OVER_TIME
		shape.deviation = 0
		game_manager.add_child(shape)
		game_manager.spawn_debt -= SPAWN_STAR_COST * game_manager.level_data.cost_adjustment

		if should_rotate:
			initial_angle += .5 * TAU
