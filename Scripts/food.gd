extends RigidBody3D

func _on_eat_area_body_entered(body: Node3D) -> void:
	if body.name.contains("Fella"):
		if body.hunger <= 25:
			body.hunger += 30
			if body.hunger > 100:
				body.hunger = 100
			queue_free()

func _on_eat_area_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event.is_action_pressed("select"):
		Global.oranges += 1
		queue_free()
