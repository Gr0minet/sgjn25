extends ScrollContainer



#func _gui_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		#if (
			#mouse_event.button_index == MOUSE_BUTTON_WHEEL_DOWN
			#or mouse_event.button_index == MOUSE_BUTTON_WHEEL_UP
		#):
			#get_viewport().set_input_as_handled()
