class_name LevelLabel extends Label

var tween: Tween
@onready var progress := $Progress as TextureProgressBar

func _ready() -> void:
	Events.died.connect(hide_label)
	Events.intro_finished.connect(show_label)
	Events.level_changed.connect(level_changed)
	Events.score_changed.connect(score_changed)
	modulate.a = 0

func hide_label() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = Animations.animate_out(self)

func show_label() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = Animations.animate_in(self)

func level_changed(level: int) -> void:
	if level <= 0: return
	text = str(level)
	if tween and tween.is_running():
		return
	tween = Animations.pop(self)

func score_changed(score: int) -> void:
	progress.value = score % 150
