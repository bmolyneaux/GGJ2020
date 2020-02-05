extends Spatial

func _ready():
	# The particles are set to emitting in the scene so that the shader is
	# compiled on startup
	$CPUParticles.emitting = false
	$CPUParticles2.emitting = false

func start_animation():
	$Bounce.get_animation("Bounce").loop = true
	$CPUParticles.emitting = true
	$CPUParticles2.emitting = true
	get_node("Bounce").play("Bounce")
