extends Node2D

func play_sound(stream: AudioStream) -> void:
	var audio := AudioStreamPlayer.new()
	audio.stream = stream
	add_child(audio)
	audio.play()
	await audio.finished
	audio.queue_free()
