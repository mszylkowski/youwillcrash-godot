class_name BoomerangObstacle extends SimpleObstacle

@export var max_turn_acceleration := .5 ## Maximum sideways acceleration

var turn_accel: float

func _ready() -> void:
	super._ready()
	turn_accel = randf_range(max_turn_acceleration * .5, max_turn_acceleration) * [-1, 1].pick_random()
	angular_velocity = turn_accel * 30

func _physics_process(_delta: float) -> void:
	if GameState.SCREEN.has_point(position):
		var vel := linear_velocity
		var accel := Vector2(-vel.y, vel.x) * turn_accel
		apply_force(accel)
