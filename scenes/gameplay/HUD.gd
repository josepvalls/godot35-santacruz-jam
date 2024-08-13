extends CanvasLayer
class_name HUDLayer

func update_health(value: float):
	$"%HealthBar".value = value

func update_score(value: int):
	$Score.text = "Score: " + str(value)
