extends Area2D

class_name Missel

@export var speed = 300
@onready var shoot_sound = preload("res://audio/laser.wav")

func _ready():
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = shoot_sound
	audio_player.volume_db = -20  
	audio_player.play()

func _process(delta):
	position.y -= speed * delta
