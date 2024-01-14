extends Label3D


# Called when the node enters the scene tree for the first time.
func updateText():
	if(get_parent().get_parent().file != null):
		text = get_parent().get_parent().file.name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
