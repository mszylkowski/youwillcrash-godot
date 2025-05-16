extends Node2D

@onready var animation := %AnimationPalayer as AnimationPlayer

func toggle(value: bool) -> void:
	animation.play("hide", -1, 1 if value else -1)
