extends RigidBody2D

@export var speed := 200.0
@export var offset_x := 250.
@export var offset_y := 400.

func _ready() -> void:
	var angle = randi() % 4
	global_rotation_degrees = angle * 90
	global_position = Vector2(0, 0)
	linear_velocity = -Vector2.from_angle(rotation) * speed

	var rand_val := randf() * 2 - 1
	if angle == 0:
		global_position = Vector2(offset_x * 1.5, offset_y * rand_val)
		linear_velocity = Vector2.LEFT * speed
	elif angle == 1:
		global_position = Vector2(rand_val * offset_x, offset_y * 1.5)
		linear_velocity = Vector2.UP * speed
	elif angle == 2:
		global_position = Vector2(-offset_x * 1.5, offset_y * rand_val)
		linear_velocity = Vector2.RIGHT * speed
	else:
		global_position = Vector2(rand_val * offset_x, -offset_y * 1.5)
		linear_velocity = Vector2.DOWN * speed

	var destroy_time := maxf(offset_x, offset_y) * 5. / speed
	get_tree().create_timer(destroy_time).timeout.connect(queue_free)
