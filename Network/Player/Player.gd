extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var multiplayer_synchronizer = $MultiplayerSynchronizer

func _on_tree_entered():
	set_physics_process(true)
	

func _ready():
	
#	print(multiplayer.get_unique_id())
#	multiplayer_synchronizer.set_multiplayer_authority(multiplayer.get_unique_id())
#	if not multiplayer.get_unique_id() == name.to_int():
	
	
	#if not get_multiplayer_authority() == multiplayer.get_unique_id():
		#set_physics_process(false)
	$player_name.text = "Игрок " + name
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()





