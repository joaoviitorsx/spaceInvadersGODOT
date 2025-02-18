extends Area2D

class_name InvanderShot

@export var speed = 200
@onready var shoot_sound = preload("res://audio/playershoot.wav")

func _ready():
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = shoot_sound
	audio_player.volume_db = -10  
	audio_player.play()
	
func _process(delta):
	position.y += speed * delta

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area is Player:
		(area as Player).on_player_destroyed()
		queue_free()
