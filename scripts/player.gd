extends "res://scripts/character.gd"

func _get_input():
	velocity = Vector2()
	if(stop_movement):
		return
	if Input.is_action_just_pressed("ui_hit"):
		_punch()
		return
	if Input.is_action_pressed("ui_right"):
		_move_right()
	if Input.is_action_pressed("ui_left"):
		_move_left()

func _physics_process(delta):
	_get_input()

	
