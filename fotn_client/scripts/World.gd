extends Spatial

var player = preload("res://scenes/Player.tscn")
var otherPlayer = preload("res://scenes/PlayerTemplate.tscn")

func _ready():
	Network.connect("player_is_logged", self, "handleLoggedPlayer")

func spawnPlayer(player_id, currentInstance):
	var new_player = currentInstance.instance()
	#new_player.position = position
	new_player._uid = str(player_id)
	#new_player._velocity = Vector3.ZERO
	new_player.name = "Player" + str(player_id)
	#new_player.set_translation(Vector3.ZERO)
	get_tree().get_root().add_child(new_player, true)
	
func despawnPlayer(player_id):
	get_tree().get_root().queue_free()

# TODO
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
		spawnPlayer(data.player.uid, otherPlayer)

func handleAlreadyConnectedPlayers(data):
	for _player in data:
		if !(userIsAlreadySpawn(_player)):
			spawnPlayer(_player.uid, otherPlayer)

# Spawn actual player & all others players
func load_player_parameters(data):
	spawnPlayer(data.player.uid, player)
	handleAlreadyConnectedPlayers(data.players)
