extends Control

@export var hunger = 0
@export var happiness = 0
@export var worth = 0
@export var fellaName = ""
@export var color = Color(0,0,0)
@export var face = load("res://CharacterTextures/Faces/face1.png")

func _ready() -> void:
	$HungerInfo.text = str("Hunger: ", hunger)
	$HappinessInfo.text = str("Happiness: ", happiness)
	$MoneyInfo.text = str("Worth: $", worth)
	$Name.text = fellaName
	$Face.texture = face

func _process(_delta: float) -> void:
	$HungerInfo.text = str("Hunger: ", hunger)
	$HappinessInfo.text = str("Happiness: ", happiness)
	$MoneyInfo.text = str("Worth: $", worth)
	$Background.color = color
	if hunger <= 20 or happiness <= 20:
		$Warning.visible = true
	else:
		$Warning.visible = false
