extends Node

const characterPreload = preload("res://prefabs/player.tscn")
onready var characterHealthBar = $"GUI/MarginContainer/HBoxContainer/HealthBarP1"
var character

const enemyPreload = preload("res://prefabs/enemy.tscn")
onready var enemyHealthBar = $"GUI/MarginContainer/HBoxContainer/HealthBarP2"
var enemy

onready var timerLabel  = $"GUI/MarginContainer/HBoxContainer/Label"
var fight_timer = Timer.new()

var isGameOver = false
var gameOverLabel

var dist = 0
var disp = 0

var rng

var move_timer = Timer.new()

func _ready():
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	rng = RandomNumberGenerator.new()
	gameOverLabel = Label.new()
	gameOverLabel.visible = false
	gameOverLabel.rect_position = Vector2(get_viewport().size.x / 2 - 40, get_viewport().size.y / 2 - 40)
	self.add_child(gameOverLabel)
	character = characterPreload.instance()
	character.position = Vector2(200, 500)
	self.add_child(character)

	enemy = enemyPreload.instance()
	enemy.position = Vector2(600, 500)
	enemy.scale.x = -1
	self.add_child(enemy)
	move_timer.connect("timeout", self, "_on_move_timeout")
	move_timer.wait_time = 0.4
	self.add_child(move_timer)
	move_timer.start()
	
	fight_timer.connect("timeout", self, "_on_time_over")
	fight_timer.one_shot = true
	fight_timer.wait_time = 99
	self.add_child(fight_timer)
	fight_timer.start()

	
func _game_over(text):
	gameOverLabel.text = text
	gameOverLabel.visible = true
	get_tree().paused = true

func _process_ai_move():
	enemy.velocity = Vector2()
	var y = 1.285 * exp(-0.007 * float(dist))
	rng.randomize()
	var move_back_percentage = rng.randf_range(0.0, 1.0)
	if move_back_percentage > y:
		enemy._move_left()
	else:
		enemy._move_right()
	
func _process_ai_punch():
	rng.randomize()
	var punch_percentage = rng.randf_range(0.0, 1.0)
	if dist < 63.3 and punch_percentage > 0.9:
		enemy._punch()

func _process(delta):
	disp = character.position.x - enemy.position.x
	dist = abs(disp)
	_process_ai_punch()
	if enemy.HP <= 0:
		_game_over("Player 1 Wins")
	elif character.HP <= 0:
		_game_over("Player 2 Wins")
	characterHealthBar.value = character.HP
	enemyHealthBar.value = enemy.HP
	timerLabel.text = str(int(fight_timer.get_time_left()))
	if(enemy.to_local(character.global_position).x < 0):
		print('flip enemy')
		enemy.scale.x = -1
		character.scale.x = -1
			
func _on_move_timeout():
	_process_ai_move()
	pass
	
func _on_time_over():
	_game_over('Time ran out')
