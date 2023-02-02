extends KinematicBody

onready var _anim_player = $PlayerSkin/AnimationPlayer
export var _uid := ""
var position = Vector3.ZERO

func _ready():
	Network.connect("player_has_move", self, "handlePlayerMoving")

func handlePlayerMoving(data):
	if data.player.uid == _uid:
		var origin = Vector3(data.player.position.x, data.player.position.y, data.player.position.z)
		self.global_transform.origin = origin
		self.rotation.y = data.player.look_direction
		
		if _anim_player.current_animation != "running":
			_anim_player.play("running")
