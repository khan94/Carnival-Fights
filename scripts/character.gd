extends KinematicBody2D


export (int) var speed = 200

var velocity = Vector2()
var state_machine
var stop_movement = false
var is_dead = false
var HP = 100
onready var HealthTween = $"HealthTween"

func _ready():
	state_machine = $AnimationTree.get('parameters/playback')

func _process_move():
	if(stop_movement):
		return
	velocity.x = velocity.normalized().x * speed
	if velocity.x == 0:
		state_machine.travel('idle')
	else:
		state_machine.travel('walk')


func _move_left():
	velocity.x -= 1
	
func _move_right():
	velocity.x += 1
	
func _jump():
	stop_movement = true
	velocity.y += -100
	state_machine.travel("jump")
	
func _animation_end():
	stop_movement = false

func _physics_process(delta):
	_process_move()
	if !stop_movement:
		velocity = move_and_slide(velocity)

func _punch():
	stop_movement = true
	state_machine.travel("attack")

func _got_punched():
	var updatedHealth = HP - 10
	HealthTween.interpolate_property(self, "HP",
		null, updatedHealth, .75,
		Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	HealthTween.start()
	if(HP <= 0):
		is_dead = true
#		in the future run death animation and signal to end Round??
	stop_movement = true
	state_machine.travel("hurt")


func _on_Area2D_area_entered(area):
	if area.name == 'HitArea' && area.get_parent().name != self.name:
		area.get_parent()._got_punched()
