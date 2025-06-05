@tool
class_name VisualsManager extends Node2D

@export var player_light: PointLight2D
@export var darkness_modulate: CanvasModulate
@export var game_area: CanvasGroup

@warning_ignore_start("unused_private_class_variable")
@export_tool_button("Set dark", "GuiToggleOn") var _set_dark := set_lightness.bind(false)


@export_tool_button("Set light", "GuiToggleOff") var _set_light := set_lightness.bind(true)
@warning_ignore_restore("unused_private_class_variable")

func _ready() -> void:
	if Engine.is_editor_hint(): return
	Events.level_changed.connect(level_changed.unbind(1))
	_set_light.call()

func level_changed() -> void:
	if not GameManager.level_data:
		set_lightness(true)
		return
	var is_boss := GameManager.level_data.is_boss
	if is_boss:
		set_lightness(randf() > .5)
	else:
		set_lightness(true)

func set_lightness(light: bool) -> void:
	var tween := get_tree().create_tween().set_parallel(true)
	tween.tween_property(darkness_modulate, "color", Color.WHITE if light else Color.BLACK, .3)
	tween.tween_property(player_light, "energy", 0. if light else 1., .3)
	tween.tween_property(player_light, "shadow_color", Color.BLACK if light else Color(0.0, 0.399, 0.5), .3)

	tween.tween_property(game_area.material, "shader_parameter/shadow_color:a", 1 if light else 0, .3)
