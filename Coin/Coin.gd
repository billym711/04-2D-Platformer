extends Area2D

var score = 10

func _on_Coin_body_entered(body):
	if body.name == "Player":
		Global.update_score(score)
		get_node_or_null("CoinSound").play()
		$Timer.start()




func _on_Timer_timeout():
	queue_free()
