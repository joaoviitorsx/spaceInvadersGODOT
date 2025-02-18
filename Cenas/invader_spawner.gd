extends Node2D

class_name Invader_Spawner

signal invader_destroyed(points: int)
signal game_won
signal game_lost

const rows = 5
const columns = 11
const horizontalSpacing = 32
const verticalSpacing = 32
const invaderHeight = 24
const startY = -50
var position_X_Increment = 10
const position_Y_Increment = 20 

var invaderScene = preload("res://Cenas/invader.tscn")
@onready var timer = $Timer
var movementDirection = 1
@onready var shot_timer = $ShotTimer
var invader_shot_scene = preload("res://Cenas/invander_shot.tscn")
var invader_destroyed_count = 0
var invader_total_count = rows * columns	


var speed_increment = 0.5 

func _ready():
	var invader1 = preload("res://Resouces/invader_1.tres")
	var invader2 = preload("res://Resouces/invader_2.tres")
	var invader3 = preload("res://Resouces/invader_3.tres")
	
	var invaderConfig
	
	for row in rows:
		if row == 0:	
			invaderConfig = invader1
		elif row == 1 || row == 2:
			invaderConfig = invader2
		elif row == 3 || row == 4:
			invaderConfig = invader3
		
		var rowWidth = (columns * invaderConfig.width * 3) + ((columns - 1) * horizontalSpacing)
		var startX = (position.x - rowWidth) / 2
		
		for col in columns:
			var x = startX + (col * invaderConfig.width * 3) + (col * horizontalSpacing)
			var y = startY + (row * invaderHeight) + (row * verticalSpacing)
			var spawnerPosition = Vector2(x, y)
			invaderSpawner(invaderConfig, spawnerPosition)

func invaderSpawner(invaderConfig, spawnerPosition):
	var invader = invaderScene.instantiate() as Invader 
	invader.config = invaderConfig
	invader.global_position = spawnerPosition
	invader.invader_destroyed.connect(on_invader_destroyed)
	add_child(invader)

func _on_timer_timeout():
	position.x += position_X_Increment * movementDirection

func _on_left_wall_area_entered(area):
	if (movementDirection == -1):
		position.y += position_Y_Increment
		movementDirection *= -1

func _on_right_wall_area_entered(area):
	if (movementDirection == 1):
		position.y += position_Y_Increment
		movementDirection *= -1

func _on_shot_timer_timeout():
	var shot_position = get_children().filter(func(child): return child as Invader).map(func(invader): return invader.global_position).pick_random()
	var invader_shot = invader_shot_scene.instantiate() as InvanderShot
	invader_shot.global_position = shot_position
	get_tree().root.add_child(invader_shot)


func on_invader_destroyed(points: int):
	invader_destroyed.emit(points)
	invader_destroyed_count += 1

	position_X_Increment += speed_increment
	
	if invader_destroyed_count == invader_total_count:
		game_won.emit()
		shot_timer.stop()
		timer.stop()

func _on_bottom_wall_area_entered(area):
	game_lost.emit()
	timer.stop()
	movementDirection = 0
