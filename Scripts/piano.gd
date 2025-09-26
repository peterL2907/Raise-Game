extends StaticBody3D

var canPlay = true
var pianoText = ("Select Piano Player")

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event.is_action_pressed("select"):
		$SelectIdentifier.visible = true
		$Info.visible = true
		if Global.pianoSelected == true:
			$Info/PianoButton.text = "Piano Occupied"
			canPlay = false
		elif Global.pianoSelected == false:
			canPlay = true
			if Global.selectingPiano == false:
				$Info/PianoButton.text = "Select Piano Player"
			else:
				$Info/PianoButton.text = "Cancel Choosing"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		$SelectIdentifier.visible = false
		$Info.visible = false


func _on_piano_button_pressed() -> void:
	if Global.selectingPiano == false and canPlay:
		Global.selectingPiano = true
		$Info/PianoButton.text = "Cancel Choosing"
		pianoText = "Cancel Choosing"
	elif Global.selectingPiano == true and canPlay:
		Global.selectingPiano = false
		$Info/PianoButton.text = "Select Piano Player"
		pianoText = "Select Piano Player"

func _process(_delta: float) -> void:
	if Global.pianoSelected:
		$PlayArea.monitoring = true
		$PlayParticle.emitting = true
	else:
		$PlayArea.monitoring = false
		$PlayParticle.emitting = false

func _on_play_area_body_entered(body: Node3D) -> void:
	if Global.pianoSelected and body.name.contains("Fella"):
		if body.playingPiano == false:
			print("a")
			body.listening = true
			body.listenPiano()
func _on_play_area_body_exited(body: Node3D) -> void:
	if body.name.contains("Fella"):
		body.listening = false
