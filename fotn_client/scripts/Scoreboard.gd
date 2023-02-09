extends Node2D

onready var _row = preload("res://scenes/ScoreboardRow.tscn")

func _ready():
	Network.connect("player_is_logged", self, "handleLoggedPlayer")
	Network.connect("player_is_disconnected", self, "handleDisconnectedPlayer")
	Network.connect("player_is_dead", self, "onPlayerIsDead")

func onPlayerIsDead(data):
	for _node in self.get_children():
		if _node.get_node("Name").text == data.attackPlayer.name:
			_node.get_node("Score").text = String(data.attackPlayer.kills) + " / " + String(data.attackPlayer.deaths) 
		elif _node.get_node("Name").text == data.defendPlayer.name:
			_node.get_node("Score").text = String(data.defendPlayer.kills) + " / " + String(data.defendPlayer.deaths) 

func handleLoggedPlayer(data):
	for _node in self.get_children():
		self.remove_child(_node)

	for _player in data.players:
		var nRow = _row.instance()
		nRow.get_node("Name").text = _player.name
		nRow.get_node("Score").text = String(_player.kills) + " / " + String(_player.deaths)
		nRow.position.y = 20 * self.get_children().size()
		add_child(nRow)

func handleDisconnectedPlayer(data):
	print(data)
	for _node in self.get_children():
		if _node.get_node("Name").text == data.name:
			self.remove_child(_node)
