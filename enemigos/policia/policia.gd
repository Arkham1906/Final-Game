extends Area2D

@export var bala_escena: PackedScene
@onready var spawn_point = $SpawnPoint
@onready var timer = $Timer

func _ready():
	timer.start()
	timer.timeout.connect(_on_Timer_timeout)

func _on_Timer_timeout():
	var nueva_bala = bala_escena.instantiate()
	nueva_bala.position = spawn_point.global_position
	get_tree().current_scene.add_child(nueva_bala)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		queue_free()
		get_tree().current_scene.get_node("MensajeFinal").visible = true
