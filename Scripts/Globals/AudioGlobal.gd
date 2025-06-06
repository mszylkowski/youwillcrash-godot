extends Node2D

const UI_SOUND_PREFAB := preload("res://Audio/UiSelect.wav")
const UI_SOUND_SMALL_PREFAB := preload("res://Audio/UiSelectSmall.wav")

func play_ui_sound() -> AudioStreamPlayer:
	return play_sound(UI_SOUND_PREFAB)

func play_ui_sound_small() -> AudioStreamPlayer:
	return play_sound(UI_SOUND_SMALL_PREFAB)

func play_sound(stream: AudioStream) -> AudioStreamPlayer:
	var audio := AudioStreamPlayer.new()
	audio.stream = stream
	audio.bus = "SFX"
	add_child(audio)
	audio.play()
	audio.finished.connect(audio.queue_free)
	return audio
