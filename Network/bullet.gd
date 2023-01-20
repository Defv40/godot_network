extends CharacterBody2D


var speed : int = 1000
# Called when the node enters the scene tree for the first time.
func _ready():
	#velocity.x = get_local_mouse_position().x * speed
	#velocity.y = get_local_mouse_position().y * speed
	velocity = get_local_mouse_position().normalized() * speed
	
	get_tree().create_timer(1).timeout.connect(func(): queue_free())
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#velocity.x = -29
	#velocity.y = -64
	#print(get_global_mouse_position())

	move_and_slide()



func _on_area_2d_body_entered(body):
	if body.name.match("Enemy*"):
		body.queue_free()
