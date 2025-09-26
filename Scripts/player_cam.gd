extends Camera3D

var current_pos = 0

func _physics_process(_delta: float) -> void:
	#move camera
	if Input.is_action_just_pressed("move_left") and not Global.currentlySpectating:
		current_pos -= 1
	elif Input.is_action_just_pressed("move_right") and not Global.currentlySpectating:
		current_pos += 1
	if current_pos < -2:
		current_pos = 1
	elif current_pos > 1:
		current_pos = -2
	if current_pos == 0:
		position = Vector3(-9.669,3.242,0)
		rotation_degrees = Vector3(-7.7,-90.0,0.0)
	elif current_pos == -1:
		position = Vector3(0,3.242,-9.669)
		rotation_degrees = Vector3(-7.7,180.0,0.0)
	elif current_pos == -2:
		position = Vector3(9.669,3.242,0)
		rotation_degrees = Vector3(-7.7,90.0,0.0)
	elif current_pos == 1:
		position = Vector3(0,3.242,9.669)
		rotation_degrees = Vector3(-7.7,0.0,0.0)
	if Input.is_action_just_pressed("move_up") and not Global.currentlySpectating:
		get_parent().get_node("BirdeyeCamera").current = true
		current = false
	if Input.is_action_just_pressed("move_down") and not Global.currentlySpectating:
		current = true
		get_parent().get_node("BirdeyeCamera").current = false
		
	if Input.is_action_just_pressed("duplicate"):
		var clone = load("res://Scenes/fella.tscn").instantiate()
		print(Global.fellas)
		get_parent().add_child(clone)
		clone.position = Vector3(randi_range(-10,10),0,randi_range(-10,10))


func _on_music_finished() -> void:
	get_parent().get_node("Piano/Music").play()
