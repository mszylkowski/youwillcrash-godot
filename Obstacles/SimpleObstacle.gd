extends RigidBody2D

@export var speed := 200.0
@export var offset := 600
@export_range(0, 90, .1, "radians_as_degrees") var deviation_radians := .4
@export_range(0, 360, .1, "radians_as_degrees") var rotation_speed := 0.

func _ready() -> void:
	var angle = randf() * TAU
	var deviation = randf() * deviation_radians
	rotation = angle + deviation
	global_position = Vector2.from_angle(angle) * offset
	linear_velocity = -Vector2.from_angle(rotation) * speed
	angular_velocity = randf() * rotation_speed

	var destroy_time := offset * 2 / speed
	get_tree().create_timer(destroy_time).timeout.connect(queue_free)
