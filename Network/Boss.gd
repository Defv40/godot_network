extends Node2D

@onready var animation_player = $"AnimationPlayer"
# Called when the node enters the scene tree for the first time.
func _ready():
	return
	animation_player.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_animation_player_animation_finished(anim_name):
	animation_player.play(anim_name)
