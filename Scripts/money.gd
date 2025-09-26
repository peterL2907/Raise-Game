extends Control

var currentFellaCost = float(15)
var fellaInfoOpen = false

func _process(_delta: float) -> void:
	$MoneyAmount.text = str("$", snapped(Global.cash,0.01))
	$OrangeAmount.text = str(Global.oranges)

func _on_shop_button_pressed() -> void:
	$Shop.visible = true
	$ShopButton.visible = false
	fellaInfoOpen = false
	$FellaInfoBox.visible = false
	$FellaInfoButton.text = "Fella Info"

func _on_close_shop_pressed() -> void:
	$Shop.visible = false
	$ShopButton.visible = true

#Shop functionality
func _on_buy_button_pressed() -> void:
	if Global.cash >= 5:
		$Shop/Purchase.play()
		Global.cash -= 5
		var food = load("res://Scenes/food.tscn").instantiate()
		get_parent().add_child(food)
		food.position = get_parent().get_node("FoodPos").position
func _on_buy_button_2_pressed() -> void:
	if Global.cash >= currentFellaCost:
		$Shop/Purchase.play()
		Global.cash -= currentFellaCost
		var fella = load("res://Scenes/fella.tscn").instantiate()
		get_parent().add_child(fella)
		currentFellaCost += snapped((currentFellaCost/100) * 20, 0.01)
		$Shop/Items/Character/Price.text = str("$", currentFellaCost)

#fella info
func _on_fella_info_button_pressed() -> void:
	if fellaInfoOpen == false:
		fellaInfoOpen = true
		$FellaInfoBox.visible = true
		$FellaInfoButton.text = "Close"
	else:
		fellaInfoOpen = false
		$FellaInfoBox.visible = false
		$FellaInfoButton.text = "Fella Info"
