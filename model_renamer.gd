extends Control
@onready var sfx1 = $SuccessSFX
@onready var sfx2 = $FailSFX
@onready var honey = $SubViewport/HoneyHead
@onready var blender = $SubViewport/BlenderLogo
@onready var bg = $BG
@onready var bgFlash = $BGFlash
@onready var console = $Console
var speen = 0
var circledist := 1.75
var spinvel = 1
func _ready():
	bgFlash.modulate.a=0.0
	get_viewport().files_dropped.connect(on_files_dropped)

func on_files_dropped(files):
	print(files)
	#rename_to_honeypatcher(file)
	var errored=false
	var success=0
	var fail=0
	for i in files:
		if RenameFile(i):
			errored=true
			fail+=1
		else:
			success+=1
	console.text=""
	if success>0:
		if success==1:
			console.text=console.text+"1 file successfully renamed!"
		else:
			console.text=console.text+str(success)+" files successfully renamed!"
		if fail>0:
			console.text=console.text+"\n"
	if fail>0:
		if fail==1:
			console.text=console.text+"1 file unsuccessfully renamed..."
		else:
			console.text=console.text+str(fail)+" files unsuccessfully renamed..."
	bgFlash.modulate.a=0.5
	if errored:
		sfx2.play()
		spinvel-=3
		
		bgFlash.modulate.g=0.0
		bgFlash.modulate.b=0.0
	else:
		sfx1.play()
		spinvel+=20
		bgFlash.modulate.g=1.0
		bgFlash.modulate.b=1.0

func RenameFile(path):
	var filetype=0
	var out = path
	out=out.reverse()
	var slash=out.find("\\")
	out=out.reverse()
	var folder = out.left(len(out)-slash)
	var nameAndExtension = out.right(slash)
	var name = nameAndExtension.left(nameAndExtension.find("."))
	var fileExtension = nameAndExtension.right(len(nameAndExtension)-nameAndExtension.find("."))
	var namesplit=0
	print(namesplit)
	var modelname
	var modelid
	var newpath
	for i in len(name):
		if name[i].is_valid_int():
			namesplit=i
			break
	if namesplit==0:
		print("converting to injector")
		filetype=1
		namesplit=0
		for i in len(name):
			if name[i]=="_":
				namesplit=i
				break
		if namesplit==0:
			print("file name didn't match either type")
			return true
		else:
			modelid = (name.left(namesplit))
			modelid=str(int(modelid))
			modelname = (name.right(len(name)-namesplit))
			modelname = modelname.right(len(modelname)-1)
	else:
		modelname = (name.left(namesplit))
		modelid = (name.right(len(name)-namesplit)).pad_zeros(4)
	if filetype==0:
		newpath = folder+modelid+"_"+modelname+fileExtension
	else:
		newpath = folder+modelname+modelid+fileExtension
	print(newpath)
	if not (fileExtension==".stfmdl" or fileExtension==".stfmat" or fileExtension==".stfuvs"):
		return true
	return DirAccess.rename_absolute(path,newpath)
	
func _process(delta: float) -> void:
	bgFlash.modulate.a=move_toward(bgFlash.modulate.a,0.0,delta*1.5)
	honey.rotation.y=sin(speen*2)*0.3
	honey.rotation.x=sin(speen*1.72)*0.3
	honey.rotation.z=sin(speen*1.81)*0.3
	honey.position.x=sin(speen)*circledist*1.3
	honey.position.y=cos(speen)*circledist
	blender.position.x=sin(speen+PI)*circledist*1.3
	blender.position.y=cos(speen+PI)*circledist
	speen+=delta*spinvel
	spinvel=lerpf(spinvel,1,delta*2)
	bg.position.x-=delta*50
	bg.position.x=fmod(bg.position.x+256,-128)-256
	bg.position.y+=delta*30
	bg.position.y=fmod(bg.position.y+256,-128)-256
