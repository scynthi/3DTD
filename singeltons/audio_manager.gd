extends Node

var volume : float = 0

enum audio_library {STEPS, PLAYER_DIE, PORTAL_SHOOT}
const _audio_dict = {
	audio_library.STEPS: preload("res://assets/sounds/sound_effects/steps.wav"),
	audio_library.PLAYER_DIE: preload("res://assets/sounds/sound_effects/die.wav"),
	audio_library.PORTAL_SHOOT: preload("res://assets/sounds/sound_effects/portal_shoot.wav"),
	
}

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func play_sfx(sfx: int, apply_randomizer : bool = true) -> void:
	var audio_player : AudioStreamPlayer = AudioStreamPlayer.new()
	var audio : AudioStream = _audio_dict[sfx]
	
	audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
	
	if apply_randomizer:
		var modifier : AudioStreamRandomizer = AudioStreamRandomizer.new()
		modifier.add_stream(0, audio)
		modifier.random_pitch = 1.5
		
		audio_player.stream = modifier
	else:
		audio_player.stream = audio
	
	audio_player.volume_db = volume
	audio_player.finished.connect(audio_player.queue_free)
	get_tree().current_scene.add_child(audio_player)
	audio_player.play()
	
