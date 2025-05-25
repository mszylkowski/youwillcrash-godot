class_name Level extends Resource

enum Obstacles {V, V_FLEET, BAR, STAR, TRIANGLE, SNAKE}

const OBSTACLE_PREFABS: Dictionary[Obstacles, PackedScene] = {
	Obstacles.V : preload("res://Obstacles/V.tscn"),
	Obstacles.TRIANGLE: preload("res://Obstacles/Triangle.tscn"),
	Obstacles.BAR : preload("res://Obstacles/Bar.tscn"),
	Obstacles.V_FLEET: preload("res://Obstacles/VFleet.tscn"),
	Obstacles.STAR: preload("res://Obstacles/Star.tscn"),
	Obstacles.SNAKE: preload("res://Obstacles/Snake.tscn"),
}

const OBSTACLE_COST: Dictionary[Obstacles, float] = {
	Obstacles.V : 1,
	Obstacles.TRIANGLE: 1.5,
	Obstacles.BAR : 2,
	Obstacles.V_FLEET: 2.5,
	Obstacles.SNAKE: 2,
	Obstacles.STAR: 4,
}

static var rng := RandomNumberGenerator.new()
var probabilities: Dictionary[Obstacles, float]
var cost_adjustment: float

static func from_number(number: int) -> Level:
	var adjustment := 1 / (.6 * log(number) + 1.5)

	match number:
		1: return Level.new({Obstacles.V: 1}, adjustment)
		2: return Level.new({Obstacles.TRIANGLE: .8, Obstacles.V: .2}, adjustment)
		3: return Level.new({Obstacles.BAR: .7, Obstacles.TRIANGLE: .15, Obstacles.V: .15}, adjustment)
		4: return Level.new({Obstacles.V_FLEET: .7, Obstacles.BAR: .15, Obstacles.V: .15}, adjustment)
		6: return Level.new({Obstacles.SNAKE: .7, Obstacles.BAR: .1, Obstacles.V: .1}, adjustment)
		5: return Level.new({Obstacles.STAR: .6, Obstacles.BAR: .2, Obstacles.TRIANGLE: .2}, adjustment)

	var shapes_count: int = [1, 2, 3, 4][rng.rand_weighted([7, 5, 3, 1])]
	var probs: Dictionary[Obstacles, float] = {}
	for _i in range(shapes_count):
		var shape := OBSTACLE_PREFABS.keys().pick_random() as Obstacles
		probs.set(shape, probs.get_or_add(shape, 0) + randf_range(0.2, 0.5))
	return Level.new(probs, adjustment)

func _init(probs: Dictionary[Obstacles, float], adjustment: float) -> void:
	probabilities = probs
	cost_adjustment = adjustment

## Returns the cost of having spawned the shape.
func spawn_shape(parent: Node2D) -> float:
	var shapes: Array[Obstacles] = probabilities.keys()
	var p := [] as Array[float]
	p.assign(shapes.map(func(s: Obstacles) -> float: return probabilities.get(s)))
	var selected := shapes[rng.rand_weighted(p)]
	var node := OBSTACLE_PREFABS[selected].instantiate() as Node2D
	parent.add_child(node)
	return OBSTACLE_COST.get(selected) * cost_adjustment
