extends Node

var save_path := "user://savegame.save"

func save_game(player_position: Vector2, monedas: int, salto: float, collected_coins: Array, victory := false, nivel_actual := ""):
	if victory:
		if FileAccess.file_exists(save_path):
			var dir = DirAccess.open("user://")
			if dir:
				dir.remove(save_path.get_file())
		return

	var data = {
		"position": player_position,
		"monedas": monedas,
		"salto": salto,
		"collected_coins": collected_coins,
		"victory": victory,
		"nivel_actual": nivel_actual
	}

	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_var(data)
		file.close()
	else:
		print("No se pudo abrir el archivo para guardar")

func load_game() -> Dictionary:
	if not FileAccess.file_exists(save_path):
		return {}
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file:
		var data = file.get_var()
		file.close()
		return data
	return {}
