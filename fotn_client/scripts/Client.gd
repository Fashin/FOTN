extends Node2D

var world = preload("res://scenes/World.tscn").instance()
var player_color = "blue"

func _ready():
	$PlayerColor/BlueButton.connect("pressed", self, "_change_player_color", ['blue'])
	$PlayerColor/BlackButton.connect("pressed", self, "_change_player_color", ['black'])
	$PlayerColor/RedButton.connect("pressed", self, "_change_player_color", ['red'])
	$PlayerColor/YellowButton.connect("pressed", self, "_change_player_color", ['yellow'])
	$PlayerColor/PurpleButton.connect("pressed", self, "_change_player_color", ['purple'])
	$PlayerColor/PinkButton.connect("pressed", self, "_change_player_color", ['pink'])
	$PlayerColor/GreenButton.connect("pressed", self, "_change_player_color", ['green'])
	$PlayerColor/OrangeButton.connect("pressed", self, "_change_player_color", ['orange'])
	Network.connect('player_is_login', self, 'connect_user')
	
# Connected to play button
func _on_Button_pressed():
	var pseudo = $PseudoInput.text
	
	if pseudo == '':
		$ErrorLog.text = 'Veuillez choisir un pseudo'
	else:
		Network.login(pseudo, player_color)

func connect_user(data):
	get_tree().get_root().add_child(world)
	get_tree().set_current_scene(world)
	world.load_player_parameters(data)
	get_tree().get_root().remove_child(self)


func _change_player_color(color):
	player_color = color
	$PlayerColorInfo.text = "Couleur choisit : " + color
