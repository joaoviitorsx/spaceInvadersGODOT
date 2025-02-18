extends Area2D

class_name Invader

signal invader_destroyed(points: int)

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

# Precarregar o som de explosão do invader
@onready var explosion_sound = preload("res://audio/explosion.wav")  # Certifique-se de que o caminho está correto

var config: Resource

func _ready():
	sprite_2d.texture = config.sprite
	animation_player.play(config.animation_name)

func _on_area_entered(area):
	if area is Laser or area is Missel:
		# Tocar animação de destruição
		animation_player.play("destroy")
		area.queue_free()

		# Criar um AudioStreamPlayer para tocar o som da explosão do invader
		var audio_player = AudioStreamPlayer.new()
		add_child(audio_player)
		audio_player.stream = explosion_sound
		audio_player.volume_db = -20  
		audio_player.play()

		# Use um temporizador para remover o AudioStreamPlayer após o som
		await get_tree().create_timer(audio_player.stream.get_length()).timeout
		audio_player.queue_free()



func _on_animation_player_animation_finished(anim_name):
	if anim_name == "destroy":
		queue_free()
		invader_destroyed.emit(config.points)
