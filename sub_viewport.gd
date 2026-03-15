extends SubViewport
@onready var honey = $HoneyHead
@onready var blender = $BlenderLogo
var speen = 0
var circledist := 1.75
var spinvel = 1
func _process(delta: float) -> void:
	honey.rotation.y=sin(speen*2)*0.3
	honey.rotation.x=sin(speen*1.72)*0.3
	honey.rotation.z=sin(speen*1.81)*0.3
	honey.position.x=sin(speen)*circledist*1.3
	honey.position.y=cos(speen)*circledist
	speen+=delta*1
