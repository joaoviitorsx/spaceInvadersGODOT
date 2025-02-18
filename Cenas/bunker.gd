extends Area2D

@export var sprite: Sprite2D
@export var texture_array: Array[Texture2D]
var damage = 0
var max_damage = 3

@onready var shoot_sound = preload("res://audio/explosion.wav")


func _on_area_entered(area):
	if area is Laser || area is InvanderShot:
		area.queue_free()
		if damage < max_damage:
			damage +=1
			sprite.texture = texture_array[damage - 1]
		else:
			var audio_player = AudioStreamPlayer.new()
			add_child(audio_player)
			audio_player.stream = shoot_sound
			audio_player.volume_db = -5  
			audio_player.play()
			queue_free()
	
	if area is Invader:
		queue_free()
