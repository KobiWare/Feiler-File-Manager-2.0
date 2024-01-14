extends MeshInstance3D


func setPreviewImage(imageDir):
	var mat = StandardMaterial3D.new()
	# TODO: load actual image dir
	var tex = load("res://assets/beauprizzler.png")
	mat.albedo_texture = tex
	mesh.material = mat

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
