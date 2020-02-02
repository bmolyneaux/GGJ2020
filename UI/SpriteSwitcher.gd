extends TextureRect


export(Texture) var first: Texture
export(Texture) var second: Texture

export(bool) var active := false

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = first

func _updateTexture():
	if active:
		texture = second
	else:
		texture = first

func activate():
	active = true
	_updateTexture()

func switch():
	active = not active
	_updateTexture()

