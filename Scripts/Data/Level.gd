class_name Level extends Resource

enum Obstacles {V, TRIANGLE, BAR, BOOMERANG, V_FLEET, STAR, SNAKE, V_SHOWER_BOSS, TRIANGLE_SPIRAL_BOSS, FIREWORK_BOSS}

const OBSTACLE_PREFABS: Dictionary[Obstacles, PackedScene] = {
	Obstacles.V : preload("res://Obstacles/V.tscn"),
	Obstacles.TRIANGLE: preload("res://Obstacles/Triangle.tscn"),
	Obstacles.BAR : preload("res://Obstacles/Bar.tscn"),
	Obstacles.BOOMERANG: preload("res://Obstacles/Boomerang.tscn"),
	Obstacles.V_FLEET: preload("res://Obstacles/VFleet.tscn"),
	Obstacles.STAR: preload("res://Obstacles/Star.tscn"),
	Obstacles.SNAKE: preload("res://Obstacles/Snake.tscn"),
	Obstacles.V_SHOWER_BOSS: preload("res://Obstacles/Bosses/VShowerBoss.tscn"),
	Obstacles.TRIANGLE_SPIRAL_BOSS: preload("res://Obstacles/Bosses/TriangleSpiralBoss.tscn"),
	Obstacles.FIREWORK_BOSS: preload("res://Obstacles/Bosses/FireworkBoss.tscn")
}

const OBSTACLE_COST: Dictionary[Obstacles, float] = {
	Obstacles.V : 1,
	Obstacles.TRIANGLE: 1.5,
	Obstacles.BAR : 2,
	Obstacles.BOOMERANG: 2,
	Obstacles.V_FLEET: 2.5,
	Obstacles.SNAKE: 2.5,
	Obstacles.STAR: 4,
	Obstacles.V_SHOWER_BOSS: 0,
	Obstacles.TRIANGLE_SPIRAL_BOSS: 0,
	Obstacles.FIREWORK_BOSS: 0,
}

const EASY_SHAPES: Array[Obstacles] = [Obstacles.V, Obstacles.TRIANGLE]
const MEDIUM_SHAPES: Array[Obstacles] = [Obstacles.BAR, Obstacles.BOOMERANG]
const HARD_SHAPES: Array[Obstacles] = [Obstacles.V_FLEET, Obstacles.SNAKE, Obstacles.STAR]
const BOSS_SHAPES: Array[Obstacles] = [Obstacles.V_SHOWER_BOSS, Obstacles.TRIANGLE_SPIRAL_BOSS, Obstacles.FIREWORK_BOSS]

static var _rng := RandomNumberGenerator.new()

var probabilities: Dictionary[Obstacles, float] = {}
var cost_adjustment: float
var is_boss := false

static func from_number(number: int) -> Level:
	var adjustment := 1 / (.75 * log(number) + 1.5)

	match number:
		_ when number % 5 == 0:
			return Level.new(adjustment).add(BOSS_SHAPES.pick_random(), 1).set_boss(true)
		1: return Level.new(adjustment).add(Obstacles.V, 1)
		2: return Level.new(adjustment).add(Obstacles.TRIANGLE, .7).add(Obstacles.V, .3)
		3: return Level.new(adjustment).add(MEDIUM_SHAPES.pick_random(), .6).add(Obstacles.TRIANGLE, .2).add(Obstacles.V, .2)
		4: return Level.new(adjustment).add(Obstacles.V_FLEET, .6).add(Obstacles.BAR, .2).add(EASY_SHAPES.pick_random(), .2)
		# Do not write manually the bosses here.
		6: return Level.new(adjustment).add(Obstacles.STAR, .5).add(Obstacles.BAR, .25).add(EASY_SHAPES.pick_random(), .25)
		7: return Level.new(adjustment).add(Obstacles.SNAKE, .5).add(MEDIUM_SHAPES.pick_random(), .25).add(EASY_SHAPES.pick_random(), .25)
		_:
			var shapes_count: int = [1, 2, 3, 4][_rng.rand_weighted([7, 5, 3, 1])]
			var level := Level.new(adjustment)
			for _i in range(shapes_count):
				level.add(OBSTACLE_PREFABS.keys().pick_random() as Obstacles, randf_range(0.2, 0.5))
			return level

func _init(adjustment: float) -> void:
	cost_adjustment = adjustment

func add(shape: Obstacles, probability: float) -> Level:
	probabilities.set(shape, probabilities.get_or_add(shape, 0) + probability)
	return self

## Spawns just once at first and then doesn't spawn any more.
func set_boss(value: bool) -> Level:
	is_boss = value
	return self

## Returns the spawned shape.
func spawn_shape(parent: GameManager) -> Node2D:
	var shapes: Array[Obstacles] = probabilities.keys()
	var p := [] as Array[float]
	p.assign(shapes.map(func(s: Obstacles) -> float: return probabilities.get(s)))
	var selected := shapes[_rng.rand_weighted(p)]
	var node := OBSTACLE_PREFABS[selected].instantiate() as Node2D
	parent.add_child(node)
	parent.spawn_debt -= OBSTACLE_COST.get(selected) * cost_adjustment
	return node
