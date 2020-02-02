extends TextureRect


export(Texture) var first: Texture
export(Texture) var second: Texture

export(bool) var active := false

var change_counter := 0.0
var change_anim_time := 0.3
var start_scale : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = first
	start_scale = rect_scale

func _process(delta):
	if change_counter > 0:
		change_counter -= delta
		if change_counter < 0:
			change_counter = 0
		var anim_amt = change_counter / change_anim_time
		rect_scale = (1 + 0.5 * anim_amt) * start_scale

func _updateTexture():
	if active:
		texture = second
	else:
		texture = first

func activate():
	active = true
	change_counter = change_anim_time
	_updateTexture()

func switch():
	active = not active
	_updateTexture()

