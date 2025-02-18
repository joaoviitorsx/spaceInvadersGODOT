extends Area2D

@export var sprite: Sprite2D
@export var texture_array: Array[Texture2D]
var damage = 0
var max_damage = 3

func _on_area_entered(area):
	if area is Laser || area is InvanderShot:
		area.queue_free()
		if damage < max_damage:
			damage +=1
			sprite.texture = texture_array[damage - 1]
		else:
			queue_free()
	
	if area is Invader:
		queue_free()
