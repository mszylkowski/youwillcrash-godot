class_name PerpendicularObstacle extends RigidBody2D

enum Directions {NONE = -1, RIGHT = 0, DOWN = 1, LEFT = 2, UP = 3}

@export var speed := 200.0
@export var offset_x := 250.
@export var offset_y := 400.

var force_spawn_direction := Directions.NONE ## Force the direction to spawn from.
var force_spawn_position := Vector2.ZERO ## Set the initial position it spawns at.

const VELOCITIES := [Vector2.LEFT, Vector2.UP, Vector2.RIGHT, Vector2.DOWN]

func _ready() -> void:
	var angle = randi_range(0, 3) if force_spawn_direction == Directions.NONE else force_spawn_direction
	global_rotation_degrees = angle * 90
	linear_velocity = VELOCITIES[angle] * speed

	var rand_val := randf_range(-1, 1)
	if force_spawn_position != Vector2.ZERO:
		global_position = force_spawn_position
	else:
		if angle == 0:
			global_position = Vector2(offset_x * 1.5, offset_y * rand_val)
		elif angle == 1:
			global_position = Vector2(rand_val * offset_x, offset_y * 1.5)
		elif angle == 2:
			global_position = Vector2(-offset_x * 1.5, offset_y * rand_val)
		else:
			global_position = Vector2(rand_val * offset_x, -offset_y * 1.5)

	var destroy_time := maxf(offset_x, offset_y) * 5. / speed
	get_tree().create_timer(destroy_time).timeout.connect(queue_free)
