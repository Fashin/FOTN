extends Node2D

onready var input_right = get_node("WindowDialog/Right")
onready var input_left = get_node("WindowDialog/Left")
onready var input_backward = get_node("WindowDialog/Backward")
onready var input_forward = get_node("WindowDialog/Forward")

func _input(event):
	if event is InputEventKey and event.is_action("ui_cancel") and event.is_pressed():
		if get_node("WindowDialog").visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_node("WindowDialog").hide()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			input_right.text = InputMap.get_action_list("ui_right")[0].as_text()
			input_left.text = InputMap.get_action_list("ui_left")[0].as_text()
			input_backward.text = InputMap.get_action_list("ui_down")[0].as_text()
			input_forward.text = InputMap.get_action_list("ui_up")[0].as_text()
			get_node("WindowDialog").show()

# TODO : en faire des méthodes
func _on_Button_pressed():
	var RightInputEvt = InputEventKey.new()
	var LeftInputEvt = InputEventKey.new()
	var BackwardInputEvt = InputEventKey.new()
	var ForwardInputEvt = InputEventKey.new()

	RightInputEvt.set_scancode(OS.find_scancode_from_string(input_right.text))
	LeftInputEvt.set_scancode(OS.find_scancode_from_string(input_left.text))
	BackwardInputEvt.set_scancode(OS.find_scancode_from_string(input_backward.text))
	ForwardInputEvt.set_scancode(OS.find_scancode_from_string(input_forward.text))

	InputMap.action_add_event("ui_right", RightInputEvt)
	InputMap.action_add_event("ui_left", LeftInputEvt)
	InputMap.action_add_event("ui_down", BackwardInputEvt)
	InputMap.action_add_event("ui_up", ForwardInputEvt)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_node("WindowDialog").hide()
