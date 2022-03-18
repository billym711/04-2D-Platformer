extends Area2D

var score = 10

func _on_Coin_body_entered(body):
	if body.name == "Player":
		Global.update_level(1)
		get_node("/root/Game/Player_Container/Player").position.x += 1000
		$Timer.start()




func _on_Timer_timeout():
	queue_free()
