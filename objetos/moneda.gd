extends Area2D

signal moneda_agarrada

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		moneda_agarrada.emit(self)
		queue_free()
