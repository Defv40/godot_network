extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var ray_cast_2d = $RayCast2D
var dir : Vector2 = Vector2()

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


	

func _physics_process(delta):
	# Add the gravity.
	
	if Input.is_action_pressed("Left"):
		dir.x = SPEED
	if Input.is_action_pressed("Right"):
		dir.x = -SPEED
	if Input.is_action_pressed("UP"):
		dir.y = SPEED
	if Input.is_action_pressed("DOWN"):
		dir.y = -SPEED
	position = dir
	move_and_slide()


func _on_vision_body_entered(body):
	ray_cast_2d.target_position = position.direction_to(body.position)
