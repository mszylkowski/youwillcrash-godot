extends Node2D

@export var speed := 200.0
@export var offset_x := 250.
@export var offset_y := 400.
@export var dist_between_parts := 40.0

const SNAKE_PART := preload("res://Obstacles/SnakePart.tscn") as PackedScene

func _ready() -> void:
	var angle = randi_range(0, 3)
	var lin_vel := -Vector2.from_angle(angle * PI * .5) * speed

	var glob_pos := Vector2.ZERO
	var rand_val := randf_range(-1, 1)
	if angle == 0:
		glob_pos = Vector2(offset_x * 1.5, offset_y * rand_val)
		lin_vel = Vector2.LEFT * speed
	elif angle == 1:
		glob_pos = Vector2(rand_val * offset_x, offset_y * 1.5)
		lin_vel = Vector2.UP * speed
	elif angle == 2:
		glob_pos = Vector2(-offset_x * 1.5, offset_y * rand_val)
		lin_vel = Vector2.RIGHT * speed
	else:
		glob_pos = Vector2(rand_val * offset_x, -offset_y * 1.5)
		lin_vel = Vector2.DOWN * speed

	var turn_time := (randf_range(1.3, 2)) * (offset_y if angle % 2 else offset_x) / speed
	var next_vel := Vector2(-lin_vel.y, lin_vel.x) * (1 if randf() > .5 else -1)

	for i in range(7):
		var part := SNAKE_PART.instantiate()
		add_child(part)
		if i == 0:
			part.global_position = glob_pos
		else:
			var last_part := get_child(i - 1)
			part.global_position = last_part.position - lin_vel.normalized() * dist_between_parts
		part.linear_velocity = lin_vel
		part.get_tree().create_timer(turn_time).timeout.connect(rotate_part.bind(i, next_vel))
		await get_tree().create_timer(dist_between_parts / speed).timeout

	var destroy_time := maxf(offset_x, offset_y) * 5. / speed
	await get_tree().create_timer(destroy_time).timeout
	queue_free()

func rotate_part(i: int, next_vel: Vector2) -> void:
	var part := get_child(i) as RigidBody2D
	part.linear_velocity = next_vel
	#if i > 0:
		#var first_part := get_child(0) as RigidBody2D
		#get_tree().physics_frame.connect(func():
			#print("updating")
			#part.global_position = first_part.global_position - next_vel.normalized() * dist_between_parts * i
		#, ConnectFlags.CONNECT_ONE_SHOT)
