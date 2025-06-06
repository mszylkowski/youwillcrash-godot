@tool
class_name VisualsManager extends Node2D

const DARKNESS_SOUND :=  preload("res://Audio/Darkness.wav")

@export var player_light: PointLight2D
@export var darkness_modulate: CanvasModulate
@export var game_area: CanvasGroup
@export var water_waves: Node2D

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
		set_water(false)
		return
	var is_boss := GameManager.level_data.is_boss
	if is_boss:
		var curr_light := randf() > .4
		var curr_water := curr_light and randf() > .5
		if not curr_light and player_light.energy > .5:
			Audios.play_sound(DARKNESS_SOUND)
		set_lightness(curr_light)
		set_water(curr_water)
	else:
		set_lightness(true)
		set_water(false)

func set_lightness(light: bool) -> void:
	var tween := get_tree().create_tween().set_parallel(true)
	tween.tween_property(darkness_modulate, "color", Color.WHITE if light else Color.BLACK, 1.5)
	tween.tween_property(player_light, "energy", 0. if light else 1., 1.5)
	#tween.tween_property(player_light, "shadow_color", Color.BLACK if light else Color(0.0, 0.399, 0.5), 1.5)
	tween.tween_property(game_area.material, "shader_parameter/shadow_color:a", 1 if light else 0, 1.5)
	tween.tween_property(AudioServer.get_bus_effect(2, 2) as AudioEffectPitchShift, "pitch_scale", 1. if light else 0.5, 0.5)

func set_water(water: bool) -> void:
	var tween := get_tree().create_tween().set_parallel(true)
	tween.tween_property(water_waves, "position:y", 0 if water else 980, 1.5)
	tween.tween_property(AudioServer.get_bus_effect(2, 0) as AudioEffectFilter, "cutoff_hz", 1500 if water else 20000, 1.5)
	tween.tween_property(AudioServer.get_bus_effect(2, 1) as AudioEffectChorus, "wet", .5 if water else 0., 1.5)
	await tween.finished
