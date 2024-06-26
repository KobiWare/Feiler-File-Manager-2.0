extends Area3D

var output = []
var lastClick

# File class
var file
var FilesDropdown = preload("filesDropdown.gd")
var prevKeyBackspace
var lastLeftClickTime = 10000
var prevKeyR = false


# For moving around the thingys, take the relative position to the camera, then transform
var isMoving = false

# for testing,
	#_init(Directory.new("fake_file.exe", 2, "C:/"))

func setFile(file):
	self.file = file
	get_node("CollisionShape3D/" + str(file.type)).show()
	
	get_node("CollisionShape3D/Label3D").updateText()
	
	var i = 0
	
	# Removes all the unneeded object types
	while true:
		if(str(i) != str(file.type)):
			var object = get_node_or_null("CollisionShape3D/" + str(i))
			if(is_instance_valid(object)):
				object.free()
			else:
				break
		i+=1
	
	# Preview for image
	if(file.type == 4):
		get_node("CollisionShape3D/4/MeshInstance3D").setPreviewImage(file.dir)

func _init():
	pass

func _on_mouse_entered():
	pass # Replace with function body.

func _on_mouse_exited():
	pass

func _process(delta):
	if(isMoving):
		# I dont know why this works, but it just does
		var cameraTransform = get_node("/root/Node3D/CharacterBody3D/Camera").get_global_transform()
		var direction_vector = -cameraTransform.basis.z
		
		set_global_position(get_node("/root/Node3D/CharacterBody3D").global_position + 
			direction_vector * 5
		)

func _on_input_event(camera, event, position, normal, shape_idx):
	# If any button on the mouse is pressed
	if(event.button_mask > 0):
		# Do this because you can click and drag your mouse around on the object and it will keep on calling this
		if(event.button_mask != lastClick):
			# Left click
			if(event.button_mask == 1):
				# Double-click opens file
				if(Time.get_ticks_msec() - lastLeftClickTime < 500):
					get_node("/root/Node3D/dropdown").open(file)
					print("left click")
					lastLeftClickTime = 1000
				lastLeftClickTime = Time.get_ticks_msec()
				isMoving = not isMoving
			# Right click
			if(event.button_mask == 2):
				print("set dropdown")
				get_node("/root/Node3D/dropdown").setToNewFile(file, get_viewport().get_mouse_position(), get_path())
	lastClick = event.button_mask
	#OS.execute("CMD.exe", ["/C", "cd C:/ && START powershell.exe"], output, true, true)
