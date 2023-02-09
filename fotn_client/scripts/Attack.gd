extends Node

onready var second_attack_timer = $SecondAttackTimer
onready var third_attack_timer = $ThirdAttackTimer
onready var global_attack_timer = $GlobalAttackTimer
onready var counter_timer = $CounterTimer
onready var attack_ui = $InRunningAttack/Sprite
onready var attack_ui_timmer = $InRunningAttack/NextAttackTimer
var first_attack = preload("res://assets/attack_ui/0.png")
var second_attack = preload("res://assets/attack_ui/1.png")
var third_attack = preload("res://assets/attack_ui/2.png")
var waiting_attack = preload("res://assets/attack_ui/4.png")
var _player
var _anim_player
var _sword
var _attack_step = 0

func _ready():
	# gestion des timers
	_player = get_tree().get_root().get_node("Player")
	_anim_player = _player.get_node("PlayerSkin/AnimationPlayer")
	second_attack_timer.one_shot = true
	third_attack_timer.one_shot = true
	global_attack_timer.one_shot = true
	counter_timer.one_shot = true
	global_attack_timer.connect("timeout", self, "_onGlobalAttackTimerFade")
	
	_sword = _player.get_node("PlayerSkin/Armature/Skeleton/BoneAttachment/Sword")
	_sword.get_node("SwordBody").connect("body_entered", self, "_onSwordBodyEntered")
	Network.connect("player_is_attacked", self, "handlePlayerIsAttacked")
	Network.connect("player_on_counter", self, "handlePlayerOnCounter")
	Network.connect("player_stamina_update", self, "handlePlayerStaminaUpdate")
	
	attack_ui.texture = first_attack

func _process(delta):
	if second_attack_timer.get_time_left() == 0 && third_attack_timer.get_time_left() == 0 && _attack_step != 0:
		attack_ui.texture = waiting_attack
		attack_ui_timmer.text = String(stepify(global_attack_timer.get_time_left(), 0.1))

func _input(event):
	if event is InputEventMouseButton && event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			# Attack binds animations
			if _attack_step == 0:
				global_attack_timer.start(5)
				second_attack_timer.start(1.3)
				_anim_player.play("attack_1")
				_attack_step = 1
				attack_ui.texture = second_attack
				Network.runAttack(_attack_step, _player._uid)

			elif third_attack_timer.get_time_left() == 0 && stepify(second_attack_timer.get_time_left(), 0.1) == 0.1:
				third_attack_timer.start(1.3)
				_anim_player.play("attack_2")
				_attack_step = 2
				attack_ui.texture = third_attack
				Network.runAttack(_attack_step, _player._uid)
				
			elif stepify(third_attack_timer.get_time_left(), 0.1) == 0.1:
				_anim_player.play("attack_3")
				_attack_step = 3
				Network.runAttack(_attack_step, _player._uid)
				
		elif event.button_index == BUTTON_RIGHT:
			Network.runCounter(_player._uid)
			_anim_player.play("counter")

func _onGlobalAttackTimerFade():
	attack_ui.texture = first_attack
	attack_ui_timmer.text = ""
	_attack_step = 0

func _onSwordBodyEntered(body):
	var name = body.get_name().split("_")
	if name[0] == "Others" && _attack_step != 0:
		Network.attackPlayer(_attack_step, name[1], _player._uid)

# handle if you counter
func handlePlayerOnCounter(data):
	if data.defendPlayer.uid == _player._uid:
		_player.get_node("StaminaBar/Viewport/Sprite").material.set_shader_param("stamina", data.defendPlayer.stamina / 100)

# handle if attack is on you
func handlePlayerIsAttacked(data):
	if data.defendPlayer.uid == _player._uid:
		_player.get_node("HealthBar/Viewport/Sprite").material.set_shader_param("health", data.defendPlayer.health / 100)

func handlePlayerStaminaUpdate(data):
	if data.player.uid == _player._uid:
		_player.get_node("StaminaBar/Viewport/Sprite").material.set_shader_param("stamina", data.player.stamina / 100)
