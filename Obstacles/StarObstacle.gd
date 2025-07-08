class_name StarObstacle extends RigidBody2D

enum HueShiftMode {NO_SHIFT, PER_INSTANCE, OVER_TIME}

const ACTIVATE_SOUND := preload("res://Audio/WaterClick.wav")
const EXPLODE_SOUND := preload("res://Audio/Popping.mp3")

@export var speed := 200.0
@export var offset := 600
@export_range(0, 90, .1, "radians_as_degrees") var deviation := .4
@export_range(0, 360, .1, "radians_as_degrees") var rotation_speed := 0.

@export_category("Explosion")
@export_range(0, 1, .1) var explode_deviation := 0.3
@export var spike_speed := 400.

var force_spawn_angle := -1. ## Force the angle to spawn at. Use positive numbers only, between 0 and TAU.
var force_spawn_deviation := 0. ## Force the angle to spawn at. Use positive numbers only, between 0 and TAU.
var hue_shift_style := HueShiftMode.NO_SHIFT ## Set the way that the colors will shift.

const SPIKE_PREFAB := preload("res://Obstacles/StarSpike.tscn")

func _ready() -> void:
	var angle = randf() * TAU if force_spawn_angle == -1. else force_spawn_angle
	var deviation_angle = randf_range(-deviation, deviation) if force_spawn_deviation == 0. else force_spawn_deviation
	var spawn_angle = angle + deviation_angle
	rotation = randf() * TAU
	global_position = Vector2.from_angle(angle) * offset
	linear_velocity = -Vector2.from_angle(spawn_angle) * speed
	angular_velocity = randf() * rotation_speed
	var destroy_variance := randf_range(.8 - explode_deviation, .8 + explode_deviation)
	var destroy_time := (offset / speed) * destroy_variance

	var to_shift := 0.
	if hue_shift_style == HueShiftMode.PER_INSTANCE:
		to_shift = randf_range(0, 1)
		Recolor.set_hue_shift(get_child(0), to_shift)
	elif hue_shift_style == HueShiftMode.OVER_TIME:
		var from_shift := randf_range(0, 1)
		to_shift = from_shift + randf_range(.3, .5)
		Recolor.animate_hue_shift(get_child(0), from_shift, to_shift, destroy_time)

	get_tree().create_timer(destroy_time).timeout.connect(explode.bind(to_shift))

func explode(shift = 0.) -> void:
	Audios.play_sound(ACTIVATE_SOUND)
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale", Vector2(.5, .5), .1)
	tween.tween_property(self, "scale", Vector2(1, 1), .3)
	await tween.finished
	var audio := Audios.play_sound(EXPLODE_SOUND)
	audio.pitch_scale = randf_range(.8, 1.5)
	for i in range(4):
		var spike := SPIKE_PREFAB.instantiate() as RigidBody2D
		get_parent().add_child(spike)
		spike.global_rotation_degrees = global_rotation_degrees + 90 * i
		spike.linear_velocity = Vector2.from_angle(spike.global_rotation) * spike_speed
		spike.global_position = global_position
		if shift != 0.:
			Recolor.set_hue_shift(spike.get_child(0), shift)
		spike.get_tree().create_timer(offset / spike_speed * 2.).timeout.connect(spike.queue_free)
	queue_free()
