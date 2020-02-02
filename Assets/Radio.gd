extends Spatial


func start_animation():
	$Bounce.get_animation("Bounce").loop = true
	$CPUParticles.emitting = true
	$CPUParticles2.emitting = true
	get_node("Bounce").play("Bounce")
