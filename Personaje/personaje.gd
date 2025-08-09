extends CharacterBody2D

@export var velocidad: float = 2000.0
@export var gravedad: float = 980.0
@export var salto: float = -750.0

var monedas: int = 0
var label_monedas: Label
var animated_sprite: AnimatedSprite2D

func _ready():
	label_monedas = get_node("../UI/ContadorMonedas")
	animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravedad * delta
	else:
		velocity.y = 0.0

	if global_position.y > 1000:
		get_tree().reload_current_scene()

	var direccion = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direccion.x += 1
		animated_sprite.play("caminar_derecha")
	elif Input.is_action_pressed("ui_left"):
		direccion.x -= 1
		animated_sprite.play("caminar_izquierda")
	else:
		animated_sprite.play("idle")


	var plataforma_velocity = Vector2.ZERO
	if is_on_floor():
		var colision = get_slide_collision(0)
		if colision != null and colision.get_collider() is CharacterBody2D:
			var plataforma = colision.get_collider() as CharacterBody2D
			plataforma_velocity = plataforma.velocity

	
	velocity.x = direccion.x * velocidad + plataforma_velocity.x


	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = salto

	move_and_slide()

func aumentar_salto():
	salto *= 1.1
	print("Nuevo valor de salto:", salto)

func agregar_moneda():
	monedas += 1
	label_monedas.text = str(monedas)
	print("¡Moneda agarrada!")
	aumentar_salto()

func esta_en_plataforma_blindada() -> bool:
	if is_on_floor():
		var colision = get_slide_collision(0)
		if colision != null and colision.get_collider().is_in_group("plataforma_blindada"):
			return true
	return false
