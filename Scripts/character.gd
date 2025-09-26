extends CharacterBody3D

@export var speed = 45
@export var hunger = 100
@export var happiness = 100
@export var worth = 1
@export var training = false
@export var characterName = ""
@export var can_move = true
@export var listening = false
@export var playingPiano = false
@onready var written_name = $Info/CharacterName
@onready var characterImage = $Info/Portrait/Character
@onready var characterCam = get_node("CharacterCam")
@onready var playerCam = get_parent().get_node("PlayerCam")
@onready var pianoPosition = get_parent().get_node("Piano").position
@onready var matPosition = get_parent().get_node("TrainingMat").position
var saveRotation = 0
var dead = false
var canEarnMoney = true
var spectating = false
var names = ["John","Gary","Seb","Peter","Pedro","Pierre","Jauffrey","Ciara", "Dianne", "Sean", "Katherine", "Katrina", "Carol", "Zelda", "Charlie", "Clara", "Russel", "Steven", "Kurt", "Ross", "Eric", "Johnny", "Wilson", "Ethan", "Richard", "Tyrone", "Quinn", "Yasmine", "Urgol", "Isaac", "Owen", "Patricia", "Anthony", "Sylvia", "Daniel", "Frederich", "Geoff", "Henry", "Joseph", "Kathryn", "Lauren", "Zak", "Xavier", "Candy", "Vincent", "Bobert", "Norman", "Mandy", "Natalie", "Vivi"]
var faces = [load("res://CharacterTextures/Faces/face1.png"),load("res://CharacterTextures/Faces/face2.png"),load("res://CharacterTextures/Faces/face3.png"),load("res://CharacterTextures/Faces/face4.png"),load("res://CharacterTextures/Faces/face5.png"), load("res://CharacterTextures/Faces/face6.png"), load("res://CharacterTextures/Faces/face7.png"), load("res://CharacterTextures/Faces/face8.png"), load("res://CharacterTextures/Faces/face9.png"), load("res://CharacterTextures/Faces/face10.png"),load("res://CharacterTextures/Faces/face3.png"),load("res://CharacterTextures/Faces/face11.png"),load("res://CharacterTextures/Faces/face3.png"),load("res://CharacterTextures/Faces/face12.png"),load("res://CharacterTextures/Faces/face3.png"),load("res://CharacterTextures/Faces/face13.png"),load("res://CharacterTextures/Faces/face3.png"),load("res://CharacterTextures/Faces/face14.png"),load("res://CharacterTextures/Faces/face3.png"),load("res://CharacterTextures/Faces/face15.png")]
var fellaInfo = load("res://Scenes/fella_info.tscn").instantiate()

func _ready() -> void:
	input_ray_pickable = true
	characterName = names.pick_random()
	written_name.text = str(characterName)
	$Head/Face.texture = faces.pick_random()
	characterImage.texture = $Head/Face.texture
	worth = snapped(randf_range(0.50, 5), 0.01)
	Global.fellas.append(self)
	fellaInfo.fellaName = characterName
	fellaInfo.hunger = hunger
	fellaInfo.happiness = happiness
	fellaInfo.worth = worth
	fellaInfo.face = $Head/Face.texture
	get_parent().get_node("Ui/FellaInfoBox/VBoxContainer").add_child(fellaInfo)
	while dead != true:
		await get_tree().create_timer(0.5).timeout
		if happiness <= 0 or hunger <=0:
			dead = true
			die()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	
	$Info/HungerLevel.text = str("Hunger: ", hunger)
	$Info/HappinessLevel.text = str("Happiness: ", happiness)
	$Info/MoneyLevel.text = str("Worth: $", worth)
	
	#random movement
	if can_move:
		can_move = false
		var move_dir = randi_range(0,3)
		if move_dir == 0:
			velocity.z -= speed * delta
			rotation_degrees = Vector3(0,90,4)
			saveRotation = 90
		elif move_dir == 1:
			velocity.z += speed * delta
			rotation_degrees = Vector3(0,-90,4)
			saveRotation = -90
		elif move_dir == 2:
			velocity.x -= speed * delta
			rotation_degrees = Vector3(0,180,4)
			saveRotation = 180
		elif move_dir == 3:
			velocity.x += speed * delta
			rotation_degrees = Vector3(0,0,4)
			saveRotation = 0
		await get_tree().create_timer(randi_range(2,4)).timeout
		velocity = Vector3.ZERO
		rotation_degrees = Vector3(0,saveRotation,0)
		await get_tree().create_timer(randi_range(2,8)).timeout
		can_move = true
	if playingPiano:
		can_move = false
		var direction = global_position.direction_to(pianoPosition)
		velocity = (direction * speed * delta) * 3
		look_at(pianoPosition)
	if training:
		can_move = false
		var direction = global_position.direction_to(matPosition)
		velocity = (direction * speed * delta) * 3
	if Global.night:
		can_move = false
		canEarnMoney = false
		$SleepParticles.emitting = true
	
	if hunger <= 25 or happiness <= 25:
		$Warning.visible = true
	else:
		$Warning.visible = false
	
	move_and_slide()

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("select"):
		$SelectIdentifier.visible = false
		$Info.visible = false
		if is_instance_valid(fellaInfo):
			fellaInfo.color = Color(0,0,0)

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event.is_action_pressed("select") and not dead:
		$SelectIdentifier.visible = true
		$Info.visible = true
		if is_instance_valid(fellaInfo):
			fellaInfo.color = Color(0,132,0)
		if Global.oranges > 0:
			$Info/OrangeButton.visible = true
		else:
			$Info/OrangeButton.visible = false
		if Global.selectingPiano == true or playingPiano:
			$Info/PianoButton.visible = true
		else:
			$Info/PianoButton.visible = false
		if Global.currentlySpectating == true and spectating == false:
			$Info/SpectateButton.visible = false
		else:
			$Info/SpectateButton.visible = true
		if Global.selectingTrain == true or training:
			$Info/MatButton.visible = true
		else:
			$Info/MatButton.visible = false

func _on_cash_timer_timeout() -> void:
	if canEarnMoney:
		$MoneySound.play()
		$MoneyParticle.emitting = true
		$Money.text = str("$",worth)
		$AnimationPlayer.play("money")
		Global.cash += worth

func _on_hunger_timer_timeout() -> void:
	if not dead:
		hunger -= 1
		if is_instance_valid(fellaInfo):
			fellaInfo.hunger = hunger
func _on_happiness_timer_timeout() -> void:
	if not dead:
		happiness -= 1
		if is_instance_valid(fellaInfo):
			fellaInfo.happiness = happiness
func _on_train_timer_timeout() -> void:
	if not dead:
		worth += 0.01
		worth = snapped(worth, 0.01)
		if is_instance_valid(fellaInfo):
			fellaInfo.worth = worth
		$AnimationPlayer.play("train")

func updateFellaInfo():
	if is_instance_valid(fellaInfo):
		fellaInfo.worth = snapped(worth, 0.01)
		fellaInfo.happiness = happiness
		fellaInfo.hunger = hunger

func _on_orange_button_pressed() -> void:
	$HeartParticle.emitting = true
	hunger += 30
	if hunger > 100:
		hunger = 100
	Global.oranges -= 1
	if Global.oranges <= 0:
		$Info/OrangeButton.visible = false

func _on_piano_button_pressed() -> void:
	if Global.selectingPiano == true and not training:
		Global.selectingPiano = false
		playingPiano = true
		$Info/PianoButton.text = "Stop Playing"
		$PianoTimer.start()
		Global.pianoSelected = true
		get_parent().get_node("Piano/Music").play()
	elif Global.selectingPiano == false and not training:
		playingPiano = false
		$Info/PianoButton.text = "Play Piano"
		$Info/PianoButton.visible = false
		$PianoTimer.stop()
		Global.pianoSelected = false
		can_move = true
		get_parent().get_node("Piano/Music").stop()

func listenPiano():
	if listening:
		$ListenTimer.start()

func _on_piano_timer_timeout() -> void:
	emitHearts()
	happiness += 5
	if happiness > 100:
		happiness = 100
	if is_instance_valid(fellaInfo):
		updateFellaInfo()

func _on_listen_timer_timeout() -> void:
	if listening:
		emitHearts()
		happiness += 2
		if happiness > 100:
			happiness = 100
		if is_instance_valid(fellaInfo):
			updateFellaInfo()
		if not listening:
			$ListenTimer.stop()

func emitHearts():
	$HeartParticle.emitting = true

func die():
	$ExplosionSound.play()
	$Body.visible = false
	$Head.visible = false
	$Explosion.play("blow")
	fellaInfo.queue_free()
	if playingPiano == true:
		playingPiano = false
		Global.pianoSelected = false
		get_parent().get_node("Piano/Music").stop()
	if training:
		training = false
		Global.trainSelected = false
	await get_tree().create_timer(1).timeout
	queue_free()

func _on_spectate_button_pressed() -> void:
	if Global.currentlySpectating == false and spectating == false:
		spectating = true
		Global.currentlySpectating = true
		playerCam.current = false
		characterCam.current = true
		$Info/SpectateButton.text = "Stop Spectating"
	elif Global.currentlySpectating == true and spectating == true:
		spectating = false
		Global.currentlySpectating = false
		playerCam.current = true
		characterCam.current = false
		$Info/SpectateButton.text = "Spectate"

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "money":
		$AnimationPlayer.play("RESET")


func _on_mat_button_pressed() -> void:
	if Global.selectingTrain == true and not playingPiano:
		Global.selectingTrain = false
		training = true
		$Head.freeze = true
		$Info/MatButton.text = "Stop Training"
		$TrainTimer.start()
		Global.trainSelected = true
	elif Global.selectingTrain == false and not playingPiano:
		training = false
		$Head.freeze = false
		$Info/MatButton.text = "Train"
		$Info/MatButton.visible = false
		$TrainTimer.stop()
		Global.trainSelected = false
		can_move = true
