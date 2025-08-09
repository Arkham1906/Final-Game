extends CharacterBody2D

@export var rango_movimiento = 200.0
@export var velocidad = 100.0

var posicion_inicial = Vector2.ZERO
var direccion = 1

func _ready():
	posicion_inicial = global_position

func _process(delta):
	global_position.x += velocidad * direccion * delta
	
	if abs(global_position.x - posicion_inicial.x) > rango_movimiento:
		direccion *= -1
