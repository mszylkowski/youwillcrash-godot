class_name Border extends Sprite2D

const GAME_SIZE := Vector2(260, 470)
const GAME_RADIUS := 20
const MENU_SIZE := Vector2(280, 300)
const MENU_RADIUS := 40

var tween: Tween

func _ready() -> void:
	Events.change_border.connect(change_border)
	change_border(GAME_SIZE, GAME_RADIUS)

func change_border(border_size: Vector2, border_radius: float) -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween.tween_property(material, "shader_parameter/frame_size", border_size, .5)
	tween.tween_property(material, "shader_parameter/border_radius", border_radius, .5).set_trans(Tween.TRANS_LINEAR)
