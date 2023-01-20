extends CharacterBody2D

var can_attack : bool = true
var mouse_so_close : bool = false
const SPEED = 300.0
@onready var gun_pos = $gun_pos
@onready var level_1 = $".."
@onready var bullet = preload("res://bullet.tscn")
@onready var cooldown_attack = $CooldownAttack
var reload_time : float = .2
@onready var attack_sound = $attack_sound


func attack():
	if not (can_attack and position.distance_to(get_global_mouse_position()) > 90):
		return
	var bul : CharacterBody2D = bullet.instantiate()
	bul.position = gun_pos.global_position
	level_1.add_child(bul)
	attack_sound.play()
	cooldown_attack.start(reload_time)
	can_attack = false
	
func _process(delta):
	pass

func _physics_process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		attack()
	# Add the gravity.
	if Input.is_action_pressed("DOWN"):
		velocity.y =  SPEED
	elif Input.is_action_pressed("UP"):
		velocity.y = -SPEED
	else:
		velocity.y = 0
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	look_at(get_global_mouse_position())
	
	move_and_slide()

func _on_cooldown_attack_timeout():
	can_attack = true
	
