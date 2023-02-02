extends Spatial

var player = preload("res://scenes/Player.tscn")
var otherPlayer = preload("res://scenes/PlayerTemplate.tscn")

func _ready():
	Network.connect("player_is_logged", self, "handleLoggedPlayer")
	Network.connect("player_is_disconnected", self, "despawnPlayer")

func spawnPlayer(player, currentInstance, type = "Others"):
	var new_player = currentInstance.instance()
	var origin = Vector3(player.position.x, player.position.y, player.position.z)
	
	new_player.global_transform.origin = origin
	new_player._uid = str(player.uid)
	new_player._name = str(player.name)
	new_player.name = type + "_" + str(player.uid)
	get_tree().get_root().add_child(new_player, true)
	
func despawnPlayer(data):
	for _node in get_tree().get_root().get_children():
		if _node.name == "Others_" + data.uid:
			_node.get_parent().remove_child(_node)

func userIsAlreadySpawn(player):
	var isAlreadySpawn = false
	
	if !("uid" in player):
		return false
	for _node in get_tree().get_root().get_children():
		if 'Player' in _node.name && _node._uid == player.uid:
			isAlreadySpawn = true

	return isAlreadySpawn

# check if asked player is in actual tree list
func handleLoggedPlayer(data):
	if !(userIsAlreadySpawn(data.player)):
		spawnPlayer(data.player, otherPlayer)

func handleAlreadyConnectedPlayers(data):
	for _player in data:
		if !(userIsAlreadySpawn(_player)):
			spawnPlayer(_player, otherPlayer)

# Spawn actual player & all others players
func load_player_parameters(data):
	spawnPlayer(data.player, player, "Player")
	handleAlreadyConnectedPlayers(data.players)
