extends KinematicBody

export var speed := 7.0
export var jump_strenght := 20.0
export var gravity := 50.0
export var _uid := ""

var _velocity := Vector3.ZERO
var _snap_vector := Vector3.DOWN

onready var _spring_arm: SpringArm = $SpringArm
onready var _model: Spatial = $PlayerSkin
onready var _anim_player = $PlayerSkin/AnimationPlayer

func _physics_process(delta: float) -> void:
	# retrieve move direction from input
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	move_direction.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	move_direction = move_direction.rotated(Vector3.UP, _spring_arm.rotation.y).normalized()

	# apply velocity
	_velocity.x = move_direction.x * speed
	_velocity.z = move_direction.z * speed
	_velocity.y -= gravity * delta

	# jumping control
	var just_landed := is_on_floor() && _snap_vector == Vector3.ZERO
	var is_jumping := is_on_floor() && Input.is_action_just_pressed("ui_accept")
	
	if is_jumping:
		_velocity.y = jump_strenght
		_snap_vector = Vector3.ZERO
	elif just_landed:
		_snap_vector = Vector3.DOWN

	_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)
	
	if _velocity.length() > 0.2:
		var look_direction = Vector2(_velocity.z, _velocity.x)
		_model.rotation.y = look_direction.angle()

	if (move_direction.x != 0 or move_direction.y != 0) and _anim_player.current_animation != "running":
		_anim_player.play("running")
	
	# check if has really move for cancel server spaming
	if move_direction.x != 0 || move_direction.y != 0 || move_direction.z != 0:
		var position = self.global_transform.origin
		Network.movePlayer({
			'x': position.x,
			'y': 1,
			'z': position.z
		}, _uid)

func _process(_delta: float) -> void:
	_spring_arm.translation = translation

func setUid(uid):
	_uid = uid
