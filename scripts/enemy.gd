extends "res://scripts/character.gd"

# INFO: in the future, we will remove input from the enemy
# and make this class think on its own to attack the player or move if needs to

func _get_input():
	velocity = Vector2()
	if(stop_movement):
		return
	if Input.is_key_pressed(KEY_SHIFT):
		_punch()
		return
	if Input.is_key_pressed(KEY_D):
		_move_right()
	if Input.is_key_pressed(KEY_A):
		_move_left()

func _physics_process(delta):
#	_get_input()
	pass
