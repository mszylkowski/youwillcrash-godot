@tool
class_name VisualsManager extends Node2D

@export var player_light: PointLight2D
@onready var darkness_modulate: CanvasModulate = $DarkCanvas

@export var game_area: CanvasGroup
@export var water_waves: Node2D
@export var glitch_overlay: Node2D
@export var curr_visuals: Level.Visuals = Level.Visuals.NONE:
	set(v):
		if v == curr_visuals: return
		if v == Level.Visuals.DARK or curr_visuals == Level.Visuals.DARK:
			set_darkness(v == Level.Visuals.DARK)
		if v == Level.Visuals.WATER or curr_visuals == Level.Visuals.WATER:
			set_water(v == Level.Visuals.WATER)
		if v == Level.Visuals.GLITCH or curr_visuals == Level.Visuals.GLITCH:
			set_glitch(v == Level.Visuals.GLITCH)
		curr_visuals = v

@onready var water_audio: AudioStreamPlayer = $WaterAudio
@onready var darkness_audio: AudioStreamPlayer = $DarknessAudio
@onready var glitch_audio: AudioStreamPlayer = $GlitchAudio

func _ready() -> void:
	if Engine.is_editor_hint(): return
	Events.level_changed.connect(level_changed.unbind(1))

func level_changed() -> void:
	if not GameManager.level_data:
		curr_visuals = Level.Visuals.NONE
		return
	curr_visuals = GameManager.level_data.visual

func set_darkness(dark: bool) -> void:
	if dark:
		darkness_modulate.visible = true
		darkness_audio.volume_linear = 1.
		darkness_audio.play()
	var tween := get_tree().create_tween().set_parallel(true)
	tween.tween_property(darkness_modulate, "color", Color.BLACK if dark else Color.WHITE, 1.5)
	tween.tween_property(player_light, "energy", 1. if dark else 0., 1.5)
	tween.tween_property(game_area.material, "shader_parameter/shadow_color:a", 0 if dark else 1, 1.5)
	tween.tween_property(AudioServer.get_bus_effect(2, 2) as AudioEffectPitchShift, "pitch_scale", 0.5 if dark else 1., 0.5)
	tween.set_parallel(false).tween_property(darkness_audio, "volume_linear", 0, .5)
	await tween.finished
	if not dark:
		darkness_modulate.visible = false

func set_water(water: bool) -> void:
	if water:
		water_waves.visible = true
		water_audio.volume_linear = 1.
		water_audio.play()
	var tween := get_tree().create_tween().set_parallel(true)
	tween.tween_property(water_waves, "position:y", 0 if water else 1050, 1.5)
	tween.tween_property(AudioServer.get_bus_effect(2, 0) as AudioEffectFilter, "cutoff_hz", 1500 if water else 20000, 1.5)
	tween.tween_property(AudioServer.get_bus_effect(2, 1) as AudioEffectChorus, "wet", .5 if water else 0., 1.5)
	tween.set_parallel(false).tween_property(water_audio, "volume_linear", 0, .5)
	await tween.finished
	if not water:
		water_waves.visible = false

func set_glitch(glitch: bool) -> void:
	if glitch:
		glitch_overlay.visible = true
		glitch_audio.volume_linear = 1.
		glitch_audio.play()
	var tween := get_tree().create_tween().set_parallel(true)
	tween.tween_property(glitch_overlay.material, "shader_parameter/shake_scale", 1. if glitch else 0., 1.)
	tween.set_parallel(false).tween_property(glitch_audio, "volume_linear", 0, .5)
	await tween.finished
	if not glitch:
		glitch_overlay.visible = false
