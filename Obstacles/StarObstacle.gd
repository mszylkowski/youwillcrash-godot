extends RigidBody2D

@export var speed := 200.0
@export var offset := 600
@export_range(0, 90, .1, "radians_as_degrees") var deviation := .4
@export_range(0, 360, .1, "radians_as_degrees") var rotation_speed := 0.

@export_category("Explosion")
@export_range(0, 1, .1) var explode_deviation := 0.3
@export var spike_speed := 500.

const SPIKE_PREFAB := preload("res://Obstacles/StarSpike.tscn")

func _ready() -> void:
	var angle = randf() * TAU
	var deviation_angle = randf() * deviation
	rotation = angle + deviation_angle
	global_position = Vector2.from_angle(angle) * offset
	linear_velocity = -Vector2.from_angle(rotation) * speed
	angular_velocity = randf() * rotation_speed

	var destroy_variance := 1. + explode_deviation * randf_range(-1, 1)
	var destroy_time := (offset / speed) * destroy_variance
	get_tree().create_timer(destroy_time).timeout.connect(explode)

func explode() -> void:
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale", Vector2(.5, .5), .1)
	tween.tween_property(self, "scale", Vector2(1, 1), .3)
	await tween.finished
	for i in range(4):
		var spike := SPIKE_PREFAB.instantiate() as RigidBody2D
		get_parent().add_child(spike)
		spike.global_rotation_degrees = global_rotation_degrees + 90 * i
		spike.linear_velocity = Vector2.from_angle(spike.global_rotation) * spike_speed
		spike.global_position = global_position
		spike.get_tree().create_timer(offset / spike_speed * 2.).timeout.connect(spike.queue_free)
	queue_free()
