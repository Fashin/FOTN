extends KinematicBody

onready var _anim_player = $PlayerSkin/AnimationPlayer
export var _name := ""
export var _uid := ""
var position = Vector3.ZERO

func _ready():
	Network.connect("player_has_move", self, "handlePlayerMoving")
	# TODO : merge this methods with player
	Network.connect("player_is_attacked", self, "handlePlayerIsAttacked")
	Network.connect("player_run_attack", self, "handlePlayerRunAttack")
	Network.connect("player_on_counter", self, "handlePlayerOnCounter")
	Network.connect("player_end_counter", self, "handlePlayerEndCounter")
	Network.connect("player_stamina_update", self, "handlePlayerStaminaUpdate")
	Network.connect("player_is_dead", self, "handlePlayerIsDead")
	$Name.text = _name

func handlePlayerMoving(data):
	if data.player.uid == _uid:
		var origin = Vector3(data.player.position.x, data.player.position.y, data.player.position.z)
		self.global_transform.origin = origin
		self.rotation.y = data.player.look_direction
		
		if _anim_player.current_animation != "running":
			_anim_player.play("running")

func handlePlayerIsAttacked(data):
	if data.defendPlayer.uid == _uid:
		$HealthBar/Viewport/Sprite.material.set_shader_param("health", data.defendPlayer.health / 100)

func handlePlayerRunAttack(data):
	if data.player.uid == _uid:
		_anim_player.play("attack_" + String(data.attackType))

func handlePlayerOnCounter(data):
	if data.defendPlayer.uid == _uid:
		_anim_player.play("counter")
		$StaminaBar/Viewport/Sprite.material.set_shader_param("stamina", data.defendPlayer.stamina / 100)

func handlePlayerStaminaUpdate(data):
	if data.player.uid == _uid:
		$StaminaBar/Viewport/Sprite.material.set_shader_param("stamina", data.player.stamina / 100)

func handlePlayerIsDead(data):
	if data.defendPlayer.uid == _uid:
		var origin = Vector3(data.defendPlayer.position.x, data.defendPlayer.position.y, data.defendPlayer.position.z)
		self.global_transform.origin = origin
		$StaminaBar/Viewport/Sprite.material.set_shader_param("stamina", data.defendPlayer.stamina / 100)
		$HealthBar/Viewport/Sprite.material.set_shader_param("health", data.defendPlayer.health / 100)
	elif data.attackPlayer.uid == _uid:
		$HealthBar/Viewport/Sprite.material.set_shader_param("health", data.attackPlayer.health / 100)
