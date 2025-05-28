class_name SimpleObstacle extends RigidBody2D

@export var speed := 200.0 ## Forward velocity.
@export var offset := 600 ## Distance from the center where the object is created.
@export_range(0, 90, .1, "radians_as_degrees") var deviation_radians := .4
@export_range(0, 360, .1, "radians_as_degrees") var rotation_speed := 0. ## Max rotation speed.

var force_spawn_angle := -1. ## Force the angle to spawn at. Use positive numbers only, between 0 and TAU.
var force_spawn_position := Vector2.ZERO ## Force the position to spawn at.
var force_spawn_deviation := 0. ## Set the initial deviation it spawns at. Set `deviation_radians` to get the initial deviation to be 0.

func _ready() -> void:
	var angle = randf() * TAU if force_spawn_angle == -1. else force_spawn_angle
	var deviation = randf() * deviation_radians if force_spawn_deviation == 0 else force_spawn_deviation
	rotation = angle + deviation
	if force_spawn_position != Vector2.ZERO:
		global_position = force_spawn_position
	else:
		global_position = Vector2.from_angle(angle) * offset
	linear_velocity = -Vector2.from_angle(rotation) * speed
	angular_velocity = randf() * rotation_speed

	var destroy_time := offset * 2 / speed
	get_tree().create_timer(destroy_time).timeout.connect(queue_free)
