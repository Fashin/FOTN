extends Node2D

var world = preload("res://scenes/World.tscn").instance()

func _ready():
	Network.connect('player_is_login', self, 'connect_user')
	
# Connected to play button
func _on_Button_pressed():
	var pseudo = $PseudoInput.text
	
	if pseudo == '':
		$ErrorLog.text = 'Veuillez choisir un pseudo'
	else:
		Network.login(pseudo)

func connect_user(data):
	get_tree().get_root().add_child(world)
	get_tree().set_current_scene(world)
	world.load_player_parameters(data)
	get_tree().get_root().remove_child(self)
