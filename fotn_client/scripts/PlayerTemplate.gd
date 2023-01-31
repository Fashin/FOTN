extends KinematicBody

export var _uid := ""
#onready var _anim_player = $PlayerSkin/AnimationPlayer
var position = Vector3.ZERO

func _ready():
	Network.connect("player_has_move", self, "handlePlayerMoving")

func handlePlayerMoving(data):
	if data.player.uid == _uid:
		self.global_transform.origin = Vector3(data.player.position.x, data.player.position.y, data.player.position.z)
