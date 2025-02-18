extends Node2D

@export var max_missile_shots = 3
var current_missile_shots = 0  # Contador de mísseis disparados
var missile_scene = preload("res://Cenas/missel.tscn")
var can_player_shoot = true

func _input(event):
	if Input.is_action_just_pressed("power") and can_player_shoot and current_missile_shots < max_missile_shots:
		var missile = missile_scene.instantiate() as Missel
		missile.global_position = get_parent().global_position - Vector2(0, 20)
		get_tree().root.add_child(missile)
		current_missile_shots += 1  # Incrementa o contador de mísseis disparados
		can_player_shoot = false
		missile.tree_exited.connect(_tree_exited)

func _tree_exited():
	can_player_shoot = true
	if current_missile_shots >= max_missile_shots:
		can_player_shoot = false
