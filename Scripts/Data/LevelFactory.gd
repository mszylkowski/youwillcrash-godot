class_name LevelFactory extends Node

static func classic(number: int) -> Level:
	var adjustment := 1 / (.75 * log(number) + 1.5)

	match number:
		_ when number % 5 == 0:
			return Level.new(adjustment).add(Level.BOSS_SHAPES.pick_random(), 1).set_boss(true).set_visual(Level.SPECIAL_VISUALS.pick_random())
		1: return Level.new(adjustment).add(Level.Obstacles.V, 1)
		2: return Level.new(adjustment).add(Level.Obstacles.TRIANGLE, .7).add(Level.Obstacles.V, .3)
		3: return Level.new(adjustment).add(Level.MEDIUM_SHAPES.pick_random(), .6).add(Level.Obstacles.TRIANGLE, .2).add(Level.Obstacles.V, .2)
		4: return Level.new(adjustment).add(Level.Obstacles.V_FLEET, .6).add(Level.Obstacles.BAR, .2).add(Level.EASY_SHAPES.pick_random(), .2)
		# Do not write manually the bosses here.
		6: return Level.new(adjustment).add(Level.Obstacles.STAR, .5).add(Level.Obstacles.BAR, .25).add(Level.EASY_SHAPES.pick_random(), .25)
		7: return Level.new(adjustment).add(Level.Obstacles.SNAKE, .5).add(Level.MEDIUM_SHAPES.pick_random(), .25).add(Level.EASY_SHAPES.pick_random(), .25)
		_:
			var shapes_count: int = [1, 2, 3, 4][Level._rng.rand_weighted([7, 5, 3, 1])]
			var level := Level.new(adjustment)
			for _i in range(shapes_count):
				level.add(Level.OBSTACLE_PREFABS.keys().pick_random() as Level.Obstacles, randf_range(0.2, 0.5))
			return level

static func snake_den(number: int) -> Level:
	var adjustment := 1 / (.75 * log(number) + 1.5)
	return Level.new(adjustment).add(Level.Obstacles.SNAKE_DEN_BOSS, 1).set_boss(true) \
		.set_visual(Level.SPECIAL_VISUALS.pick_random() if number % 5 else Level.Visuals.NONE)

static func firework_show(number: int) -> Level:
	var adjustment := 1 / (.75 * log(number) + 1.5)
	if number % 5 == 0:
		return Level.new(adjustment).add(Level.Obstacles.FIREWORK_BOSS, 1).set_boss(true).set_visual(Level.SPECIAL_VISUALS.pick_random())
	elif number % 5 == 4:
		Level.new(adjustment).add(Level.Obstacles.STAR, 1).add(Level.MEDIUM_SHAPES.pick_random(), randf_range(.3, .7))
	if randf() > .5:
		return Level.new(adjustment).add(Level.Obstacles.STAR, 1)
	return Level.new(adjustment).add(Level.Obstacles.STAR, 1).add(Level.EASY_SHAPES.pick_random(), randf_range(.3, .7))

static func firework_hell(number: int) -> Level:
	var adjustment := 1 / (.75 * log(number) + 1.5)
	return Level.new(adjustment).add(Level.Obstacles.FIREWORK_BOSS, 1).set_boss(true) \
		.set_visual(Level.SPECIAL_VISUALS.pick_random() if number % 5 else Level.Visuals.NONE)

static func all_bosses(number: int) -> Level:
	var adjustment := 1 / (.75 * log(number) + 1.5)
	return Level.new(adjustment).add(Level.BOSS_SHAPES.pick_random(), 1).set_boss(true) \
		.set_visual(Level.SPECIAL_VISUALS.pick_random() if number % 5 else Level.Visuals.NONE)

static func red_shower(number: int) -> Level:
	var adjustment := 1 / (.75 * log(number) + 1.5)
	if number % 5 == 0:
		return Level.new(adjustment).add(Level.Obstacles.V_SHOWER_BOSS, 1).set_boss(true).set_visual(Level.SPECIAL_VISUALS.pick_random())

	var v_shapes := [Level.Obstacles.V, Level.Obstacles.V_FLEET]
	if randf() > .5:
		return Level.new(adjustment).add(v_shapes.pick_random(), .5).add(Level.MEDIUM_SHAPES.pick_random(), .5)
	return Level.new(adjustment).add(v_shapes.pick_random(), .5).add(v_shapes.pick_random(), .5)

static func pitch_black(number: int) -> Level:
	return classic(number).set_visual(Level.Visuals.DARK)
