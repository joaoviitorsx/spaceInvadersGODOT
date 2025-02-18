extends Area2D

class_name Player

signal player_destroyed
@export var speed = 350
var direction = Vector2.ZERO
@onready var collistion_rect: CollisionShape2D = $CollisionShape2D
var bounding_size_x
var start_bound
var end_bound
@onready var animation_player = $AnimationPlayer

# Precarregue o som da explosão
@onready var explosion_sound = preload("res://audio/explosion.wav")

@onready var missiles_remaining_label = $UI/HBoxContainer/powertiro  # Caminho até o Label na sua cena de UI
@onready var missile_sprite = $UI/HBoxContainer/spritemissel  # Caminho até o Sprite na sua cena de UI


@export var max_missile_shots = 3
var current_missile_shots = 0
var missile_scene = preload("res://Cenas/missel.tscn")
var can_player_shoot = true

@onready var missile_counter = $"../MissileCounter"

func _ready():
	bounding_size_x = collistion_rect.shape.get_rect().size.x
	var rect = get_viewport().get_visible_rect()
	var camera = get_viewport().get_camera_2d()
	start_bound = (camera.position.x - rect.size.x)/2
	end_bound = (camera.position.x + rect.size.x)/2

func _process(delta):
	var input = Input.get_axis("move_left","move_right")
	if input < 0:
		direction = Vector2.LEFT
	elif input > 0:
		direction = Vector2.RIGHT
	else:
		direction = Vector2.ZERO

	var delta_movement = direction.x * speed * delta
	
	if (position.x + delta_movement < start_bound + bounding_size_x * transform.get_scale().x || 
		position.x + delta_movement > end_bound - bounding_size_x * transform.get_scale().x):
		return
	
	position.x += delta_movement

func on_player_destroyed():
	speed = 0;
	animation_player.play("destroy")

# Criar um AudioStreamPlayer para tocar o som da explosão
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = explosion_sound
	audio_player.volume_db = -20  
	audio_player.play()
	
	await get_tree().create_timer(audio_player.stream.get_length()).timeout
	audio_player.queue_free()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "destroy":
		await get_tree().create_timer(1).timeout
		player_destroyed.emit()
		queue_free()
