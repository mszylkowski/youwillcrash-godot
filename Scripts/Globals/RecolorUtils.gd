## Helpers to deal with hue changes for obstacles.
class_name Recolor extends Node

const HUE_SHIFT_SHADER := preload("res://Materials/hue_shift.gdshader") as Shader

## Shifts the hue of a sprite by adding a shader.
## Can be called multiple times per node to update the shift.
static func set_hue_shift(node: Sprite2D, shift: float) -> void:
	var mat: ShaderMaterial
	if node.material and node.material is ShaderMaterial:
		mat = node.material
	else:
		mat = ShaderMaterial.new()
		mat.shader = HUE_SHIFT_SHADER
		node.material = mat
	mat.set_shader_parameter("shift_hue", shift)

static func animate_hue_shift(node: Sprite2D, from_shift: float, to_shift = from_shift + .5, time = 2.) -> Tween:
	var mat: ShaderMaterial
	if node.material and node.material is ShaderMaterial and node.material.shader == HUE_SHIFT_SHADER:
		mat = node.material
	else:
		mat = ShaderMaterial.new()
		mat.shader = HUE_SHIFT_SHADER
		node.material = mat

	var tween := node.get_tree().create_tween()
	mat.set_shader_parameter("shift_hue", from_shift)
	tween.tween_property(mat, "shader_parameter/shift_hue", to_shift, time)
	return tween
