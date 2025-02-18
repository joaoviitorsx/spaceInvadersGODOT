extends Node

class_name MissileCounter

signal updated_missiles(missiles_left: int)

@export var max_missiles = 3
var missiles_left = max_missiles

func _ready():
	_update_missile_ui()  # Atualiza a UI ao iniciar

# Chame essa função quando um míssil for disparado
func decrease_missiles():
	if missiles_left > 0:
		missiles_left -= 1
		_update_missile_ui()
		updated_missiles.emit(missiles_left)

# Chame essa função para atualizar a UI
func _update_missile_ui():
	# Atualize o Label ou outro elemento da UI que exibe o número de mísseis
	var missile_label = $"../UI/HBoxContainer/powertiro"
	if missile_label:
		missile_label.text = str(missiles_left)

# Função para resetar o contador, caso necessário
func reset_missiles():
	missiles_left = max_missiles
	_update_missile_ui()
