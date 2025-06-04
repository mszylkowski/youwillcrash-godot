class_name Level extends Resource

enum Obstacles {V, TRIANGLE, BAR, BOOMERANG, V_FLEET, STAR, SNAKE, V_SHOWER_BOSS, TRIANGLE_SPIRAL_BOSS, FIREWORK_BOSS}

const OBSTACLE_PREFABS: Dictionary[Obstacles, Variant] = {
	Obstacles.V : preload("res://Obstacles/V.tscn"),
	Obstacles.TRIANGLE: preload("res://Obstacles/Triangle.tscn"),
	Obstacles.BAR : preload("res://Obstacles/Bar.tscn"),
	Obstacles.BOOMERANG: preload("res://Obstacles/Boomerang.tscn"),
	Obstacles.V_FLEET: preload("res://Obstacles/VFleet.tscn"),
	Obstacles.STAR: preload("res://Obstacles/Star.tscn"),
	Obstacles.SNAKE: preload("res://Obstacles/Snake.tscn"),
	Obstacles.V_SHOWER_BOSS: preload("res://Obstacles/Bosses/VShowerBoss.gd"),
	Obstacles.TRIANGLE_SPIRAL_BOSS: preload("res://Obstacles/Bosses/TriangleSpiralBoss.gd"),
	Obstacles.FIREWORK_BOSS: preload("res://Obstacles/Bosses/FireworkBoss.gd")
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
	var prefab = OBSTACLE_PREFABS[selected]
	var node: Node2D
	if prefab is PackedScene:
		node = prefab.instantiate()
	elif prefab is Script:
		node = prefab.new()
	else:
		push_error(prefab, " cannot be instantiated")
		return
	parent.add_child(node)
	parent.spawn_debt -= OBSTACLE_COST.get(selected) * cost_adjustment
	return node
