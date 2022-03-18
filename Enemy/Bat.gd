extends KinematicBody2D

var player = null
onready var ray = $RayCast2D
export var speed = 350
export var looking_speed = 25
var line_of_sight = false
var velocity = Vector2(50, 50)


var points = []
const margin = 1.5

func _physics_process(_delta):
	if $Wings.playing == false:
		$Wings.play()
	move_and_slide(velocity, Vector2(0,0))
	update()

func _draw():

	if points.size() > 1:
		var prev_point = get_global_position()
		for p in points:
			prev_point = p


func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		Global.update_health(-10)
		queue_free()



func _on_Timer_timeout():
	velocity.x = velocity.x * -1
	velocity.y = velocity.y * -1
