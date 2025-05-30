extends Node2D

@export_range(0.01, 1., .01) var move_time := .15  ## How often the snake moves forward
@export var offset_x := 250
@export var offset_y := 400
@export var dist_between_parts := 40.0

const SNAKE_PART := preload("res://Obstacles/SnakePart.tscn") as PackedScene

func _ready() -> void:
	var angle = randi_range(0, 3)
	var lin_vel := -Vector2.from_angle(angle * PI * .5) * dist_between_parts

	var start_pos := Vector2.ZERO
	var rand_val := randf_range(-.6, .6)
	if angle == 0:
		start_pos = Vector2(offset_x * 1.5, offset_y * rand_val)
		lin_vel = Vector2.LEFT * dist_between_parts
	elif angle == 1:
		start_pos = Vector2(rand_val * offset_x, offset_y * 1.5)
		lin_vel = Vector2.UP * dist_between_parts
	elif angle == 2:
		start_pos = Vector2(-offset_x * 1.5, offset_y * rand_val)
		lin_vel = Vector2.RIGHT * dist_between_parts
	else:
		start_pos = Vector2(rand_val * offset_x, -offset_y * 1.5)
		lin_vel = Vector2.DOWN * dist_between_parts

	var turn_move_max := (offset_y if angle % 2 else offset_x) * 3 / dist_between_parts
	var turn_move := randi_range(roundi(turn_move_max * .25), roundi(turn_move_max * .75))
	print("Snake (max=", turn_move_max, ", move=", turn_move, ")")
	var next_vel := Vector2(-lin_vel.y, lin_vel.x) * (1 if randf() > .5 else -1)
	var length := randi_range(5, 8)

	var curr_pos := start_pos

	for i in range(length - 1, -1, -1):
		var part := SNAKE_PART.instantiate() as Node2D
		curr_pos = start_pos - lin_vel.normalized() * i * dist_between_parts
		part.global_position = curr_pos
		add_child(part)

	var total_turn_move_max := (offset_y + offset_x) * 2 / dist_between_parts
	for i in range(total_turn_move_max):
		curr_pos += lin_vel if (i < turn_move) else next_vel
		var part := get_child(0) as Node2D
		part.global_position = curr_pos
		scale_up(part)
		move_child(part, get_child_count() - 1)
		await get_tree().create_timer(move_time).timeout

	queue_free()

func scale_up(part: Node2D) -> void:
	var tween := part.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	var part_sprite := part.get_child(0) as Node2D
	var part_scale := part_sprite.scale
	part_sprite.scale = Vector2.ZERO
	tween.tween_property(part_sprite, "scale", part_scale, move_time)
