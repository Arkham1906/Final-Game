extends Area2D

var velocidad = -2000  

func _process(delta):
	position.x += velocidad * delta  

func _on_body_entered(body):
	if body is CharacterBody2D:
		if body.has_method("esta_en_plataforma_blindada") and body.esta_en_plataforma_blindada():
			print("Protegido por plataforma blindada. No hay daño.")
		else:
			get_tree().reload_current_scene()
		queue_free()
