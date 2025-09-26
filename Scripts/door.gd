extends StaticBody3D

func _on_door_timer_timeout() -> void:
	var doorTime = randi_range(1,2)
	if doorTime == 1:
		var doorEvent = randi_range(1,12)
		if doorEvent == 1:
			$Knock.play()
			for i in range(0,3):
				var food = load("res://Scenes/food.tscn").instantiate()
				get_parent().add_child(food)
				food.position = $DoorSpawnPos.global_position
			$Event.text = "A mysterious man graciously gave you 3 oranges!"
			$Event.visible = true
			await get_tree().create_timer(5).timeout
			$Event.visible = false
		elif doorEvent == 2:
			$Knock.play()
			$Event.visible = true
			$MoneySound.play()
			var moneyToAdd = snapped((Global.cash / 100) * 10, 0.01)
			$Event.text = str("A mysterious man dropped $",moneyToAdd," at your door!")
			$Money.text = str("$",moneyToAdd)
			$Money.visible = true
			$AnimationPlayer.play("money")
			Global.cash += moneyToAdd
			await get_tree().create_timer(1).timeout
			$Money.visible = false
			await get_tree().create_timer(4).timeout
			$Event.visible = false
		elif doorEvent == 3:
			print(Global.fellas.size())
			if Global.fellas.size() > 1:
				$Knock.play()
				var fella = Global.fellas.pick_random()
				$Event.visible = true
				$Event.text = str("A mysterious man just shot ",fella.characterName," and ran!")
				fella.die()
				await get_tree().create_timer(5).timeout
				$Event.visible = false
		elif doorEvent == 4:
			$Knock.play()
			$Event.visible = true
			var fella = load("res://Scenes/fella.tscn").instantiate()
			get_parent().add_child(fella)
			$Event.text = str("A mysterious man just gave you ",fella.characterName," and now they are yours to keep!")
			await get_tree().create_timer(5).timeout
			$Event.visible = false
		elif doorEvent == 5:
			print(Global.fellas.size())
			if Global.fellas.size() > 1:
				$Knock.play()
				var fella = Global.fellas.pick_random()
				$Event.visible = true
				$Event.text = str("A mysterious man just complimented ",fella.characterName," and they are now worth more!")
				fella.worth += 1.00
				fella.updateFellaInfo()
				await get_tree().create_timer(5).timeout
				$Event.visible = false
		elif doorEvent == 6:
			print(Global.fellas.size())
			if Global.fellas.size() > 1:
				var fella = Global.fellas.pick_random()
				if fella.worth > 2.00:
					$Knock.play()
					$Event.visible = true
					$Event.text = str("A mysterious man just insulted ",fella.characterName," and they are now worth less!")
					fella.worth -= 1.00
					fella.updateFellaInfo()
					await get_tree().create_timer(5).timeout
					$Event.visible = false
		elif doorEvent == 7:
			print(Global.fellas.size())
			if Global.fellas.size() > 1:
				var fella = Global.fellas.pick_random()
				if fella.happiness > 30:
					$Knock.play()
					$Event.visible = true
					$Event.text = str("A mysterious man just told ",fella.characterName," their life is meaningless and they are now sadder!")
					fella.happiness -= 25
					fella.updateFellaInfo()
					await get_tree().create_timer(5).timeout
					$Event.visible = false
		elif doorEvent == 8:
			print(Global.fellas.size())
			if Global.fellas.size() > 1:
				var fella = Global.fellas.pick_random()
				if fella.hunger > 30:
					$Knock.play()
					$Event.visible = true
					$Event.text = str("A mysterious man just slowly ate a burger infront of ",fella.characterName," and now they are hungrier!")
					fella.hunger -= 25
					fella.updateFellaInfo()
					await get_tree().create_timer(5).timeout
					$Event.visible = false
		elif doorEvent == 9:
			print(Global.fellas.size())
			if Global.fellas.size() > 1:
				var fella = Global.fellas.pick_random()
				if fella.hunger > 5:
					$Knock.play()
					$Event.visible = true
					$Event.text = str("A mysterious man just gave ",fella.characterName," a burger and now they are less hungry!")
					fella.hunger += 25
					if fella.hunger > 100:
						fella.hunger = 100
					fella.updateFellaInfo()
					await get_tree().create_timer(5).timeout
					$Event.visible = false
		elif doorEvent == 10:
			print(Global.fellas.size())
			if Global.fellas.size() > 1:
				var fella = Global.fellas.pick_random()
				if fella.happiness > 5:
					$Knock.play()
					$Event.visible = true
					$Event.text = str("A mysterious man just told ",fella.characterName," that they might find buried treasure someday and they are now happier!")
					fella.happiness += 25
					if fella.happiness > 100:
						fella.happiness = 100
					fella.updateFellaInfo()
					await get_tree().create_timer(5).timeout
					$Event.visible = false
		elif doorEvent == 11:
			if Global.oranges > 3:
				$Knock.play()
				$Event.visible = true
				Global.oranges -= 3
				$Event.text = str("A mysterious man just took 3 of your oranges!")
				await get_tree().create_timer(5).timeout
				$Event.visible = false
		elif doorEvent == 12:
			$Knock.play()
			$Event.visible = true
			$MoneySound.play()
			var moneyToTake = snapped((Global.cash / 200) * 10, 0.01)
			$Event.text = str("A mysterious man stole $",moneyToTake," from you and got away!")
			Global.cash -= moneyToTake
			await get_tree().create_timer(5).timeout
			$Event.visible = false
		

func _process(_delta: float) -> void:
	$Info/Time.text = str(snapped($DoorTimer.time_left, 0))

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event.is_action_pressed("select"):
		$SelectIdentifier.visible = true
		$Info.visible = true
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		$SelectIdentifier.visible = false
		$Info.visible = false
