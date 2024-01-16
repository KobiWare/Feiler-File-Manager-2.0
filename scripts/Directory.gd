extends Node

var directory = ""
var os = OS.get_name()
var username = OS.get_environment("USERNAME")
var copyPath

class File:
	var name
	
	# 0 is unknown
	# 1 is folder
	# 2 is executable
	# 3 is a zip
	# 4 is a graphics file
	# 5 is a text document
	var type
	
	# Size in KB
	# TODO:
	var size
	var dir
	
	func _init(name, type, dir):
		self.name = name
		self.type = type
		self.dir = dir
		var file = FileAccess.open(dir + name, FileAccess.READ)
		if type == 1:
			dir += "/"
		if file != null:
			self.size = file.get_length() / 1000
		else:
			#print("test")
			self.size = 1
		
	
	func openInExplorer():
		# TODO: this will open the path to the file in file explorer
		pass
	
	func rename(name):
		# TODO: this will update the real name in the file too
		self.name = name
	
# includes folders too
var filesInDirectory = []
var currentDirectory = "C:/Users/" + username + "/"
var prevKeyR = false

func removeFileNodes():
	# Remove all previous files and reset position
	var children = get_children()
	for child in children:
		if "File" in child.name:
			child.queue_free()
		if "laser box" in child.name:
			child.queue_free()

func sortFiles(toSort):
	var children = get_children()
	print(toSort)
	for child in children:
		if "File" in child.name:
			if(!(toSort in child.file.name) and toSort != ""):
				child.hide()
			else:
				child.show()

func resolve_size(path):
	var file = FileAccess.open(path, FileAccess.READ)
	if file != null:
		return file.get_length()
	else:
		var output = [10]
		return 100

func get_length_of_path(path):
	var dir = DirAccess.open(path)
	var i = 0;
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			file_name = dir.get_next()
			i += 1
	else:
		OS.alert("An error occurred when trying to access the path.")
	print("NUM ", i)
	return i

# TODO: Combine this and update_dir_contents
func drawFiles(files, offset):
	var cubeSize = floor(pow(files.size(), 0.33334)) + 1
	var leftOverCubes = files.size() - pow(cubeSize, 3)
	print("Cube", cubeSize)
	print("leftover", leftOverCubes)
	
	var x
	var y
	var z
	
	var cubeSpacing = 6
	
	var scene = preload("res://scenes/file.tscn")
	for i in range(files.size()):
		var fileObject
		
		var path = files[i].get_base_dir() + "/"
		var file_name = files[i].get_file()
		
		if files[i].get_file() == "": # folder
			fileObject = File.new(files[i].split("/")[-2], 1, files[i])
		else: # file
			var file_type = (file_name.rsplit("."))
			file_type = file_type[file_type.size() - 1]
			match file_type:
				"exe":
					fileObject = File.new(file_name, 2, path + file_name)
				"lnk":
					fileObject = File.new(file_name, 2, path + file_name)
				"zip":
					fileObject = File.new(file_name, 3, path + file_name)
				"png":
					fileObject = File.new(file_name, 4, path + file_name)
				"jpg":
					fileObject = File.new(file_name, 4, path + file_name)
				"jpeg":
					fileObject = File.new(file_name, 4, path + file_name)
				"svg":
					fileObject = File.new(file_name, 4, path + file_name)
				"txt":
					fileObject = File.new(file_name, 5, path + file_name)
				_:
					fileObject = File.new(file_name, 0, path + file_name)
		filesInDirectory.push_back(fileObject)
		var instance = scene.instantiate()
		add_child(instance)
		
		x = fmod(i, cubeSize) * -cubeSpacing + ((cubeSize-1) / 2.0 * cubeSpacing)
		y = fmod(floor(i / cubeSize), cubeSize) * -cubeSpacing + ((cubeSize-1) / 2.0 * cubeSpacing)
		z = (floor(i / cubeSize / cubeSize)) * -cubeSpacing
		var positionVector = Vector3(float(x), float(y), float(z))
		positionVector += offset
		
		instance.position = positionVector
		instance.setFile(fileObject)
		instance.scale *= clamp(log(pow(resolve_size(path + file_name), 0.333333333333)), 0.5, 100000000)
	
	currentDirectory = currentDirectory.replace("\\", "/")
	
	var box = preload("res://assets/fileIcons/laser box.dae")
	var boxInstance = box.instantiate()
	add_child(boxInstance)
	boxInstance.scale *= 0.5
	boxInstance.scale *= cubeSpacing * cubeSize
	
	boxInstance.position = offset + Vector3(0, 0, -cubeSpacing * ((cubeSize- 1) / 2))

# Updates filesInDirectory to be the files in the current directory
func update_dir_contents(path, resetPlayerPos=true):
	removeFileNodes()
	var dir = DirAccess.open(path)
	
	# Draw the favorites dir
	print(Globals.favorites)
	drawFiles(Globals.favorites, Vector3(0, 0, 15))
	
	# Draw the current directory
	if(get_node_or_null("/root/Node3D/DirEdit") != null):
		get_node_or_null("/root/Node3D/DirEdit").text = currentDirectory
	if dir:
		# Gather all of the files/folders in the directory
		var files = []
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				file_name+="/"
			files.append(path + file_name)
			file_name = dir.get_next()
		
		# Draw the files now
		drawFiles(files, Vector3(0, 0, -15))
		
		# reset player pos
		if(get_node_or_null("/root/Node3D/CharacterBody3D") != null and resetPlayerPos):
			get_node("/root/Node3D/CharacterBody3D").global_position = Vector3(0, 0, 0)
	else:
		OS.alert("An error occurred when trying to access the path.")
	currentDirectory = currentDirectory.replace("\\", "/")

func _init():
	if OS.get_name() == "Linux":
		currentDirectory = "/"
	update_dir_contents(currentDirectory)
