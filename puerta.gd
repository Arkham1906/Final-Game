extends Area2D

@export var nivel_siguiente: String = "res://nivel_2.tscn"

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		if body.monedas >= 10:
			get_tree().change_scene_to_file(nivel_siguiente)
		else:
			print("¡Necesitas 10 monedas para entrar!")
