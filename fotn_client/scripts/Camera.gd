extends SpringArm

func _process(delta):
	if get_tree().current_scene && get_tree().current_scene.name == "World" && Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		set_as_toplevel(true)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y
		rotation_degrees.x = clamp(rotation_degrees.x, -50, -15)
		
		rotation_degrees.y -= event.relative.x
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360)
