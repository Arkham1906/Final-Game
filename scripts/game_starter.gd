extends Node

func _ready():
	var save_data = SaveManager.load_game()
	if save_data.has("nivel_actual") and save_data["nivel_actual"] != "":
		var nivel = save_data["nivel_actual"]
		var ruta = "res://%s.tscn" % nivel
		print("Intentando cargar nivel guardado:", nivel)
		print("Ruta:", ruta)

		if ResourceLoader.exists(ruta):
			get_tree().change_scene_to_file(ruta)
		else:
			print("No se encontró la escena guardada. Cargando nivel_1 por defecto.")
			get_tree().change_scene_to_file("res://nivel_1.tscn")
	else:
		print("No hay nivel guardado. Cargando nivel_1 por defecto.")
		get_tree().change_scene_to_file("res://nivel_1.tscn")
