extends CharacterBody2D

@export var velocidad: float = 2000.0
@export var gravedad: float = 980.0
@export var salto: float = -750.0

var monedas: int = 0
var collected_coins: Array = []
var label_monedas: Label
var animated_sprite: AnimatedSprite2D

func _ready():
	label_monedas = get_tree().current_scene.get_node("UI/ContadorMonedas")
	animated_sprite = $AnimatedSprite2D

	var save_data = SaveManager.load_game()
	if save_data.size() > 0:
		var nivel_guardado = save_data.get("nivel_actual", "")
		var nivel_actual = get_tree().current_scene.name
		if nivel_guardado == nivel_actual:
			global_position = save_data["position"]
			monedas = save_data["monedas"]
			salto = save_data["salto"]
			collected_coins = save_data["collected_coins"]
			label_monedas.text = str(monedas)

			for coin in get_tree().get_nodes_in_group("Coins"):
				if coin.name in collected_coins:
					coin.queue_free()

			if save_data.has("victory") and save_data["victory"]:
				get_tree().current_scene.get_node("MensajeFinal").visible = true
		else:
			monedas = 0
			collected_coins = []
			label_monedas.text = "0"


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravedad * delta
	else:
		velocity.y = 0.0

	if global_position.y > 1000:
		get_tree().reload_current_scene()

	var direccion = Vector2.ZERO
	if Input.is_key_pressed(KEY_D):
		direccion.x += 1
		animated_sprite.play("caminar_derecha")
	elif Input.is_key_pressed(KEY_A):
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

func agregar_moneda(coin_node):
	monedas += 1
	label_monedas.text = str(monedas)
	collected_coins.append(coin_node.name)
	aumentar_salto()
	
func esta_en_plataforma_blindada() -> bool:
	if is_on_floor():
		var colision = get_slide_collision(0)
		if colision != null and colision.get_collider().is_in_group("plataforma_blindada"):
			return true
	return false

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		SaveManager.save_game(
			global_position,
			monedas,
			salto,
			collected_coins,
			false,
			get_tree().current_scene.name  
		)
		get_tree().quit()
