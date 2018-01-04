extends Control

var button = null
var buttonCheck = null
var newButton = null
var newLabel = null
var y = 0
var addWeb = null
var imgTexture = null
var position = null

func _ready():
	if LOAD.actualChapter == 1:
		position = 1
		get_node("Sprite").set_pos(Vector2(position,1))
		get_node("Chapitre").set_text(str(LOAD.menuText[4]," ",LOAD.actualChapter))
	else:
		position = 1080
		for i in range(LOAD.actualChapter):
			position -= 1080
			get_node("Sprite").set_pos(Vector2(position,1))
			get_node("Chapitre").set_text(str(LOAD.menuText[4]," ",LOAD.actualChapter))

	print(LOAD.actualChapter)
	if LOAD.fileExists == false:
		get_node("Start").set_text(str(LOAD.menuText[0]))
	else:
		get_node("Start").set_text(str(LOAD.menuText[1]))

	#get_node("Option").set_text(str(LOAD.menuText[2]))
	get_node("Quitter").set_text(str(LOAD.menuText[3]))
		

	# Textes SelectChapter
	get_node("SelectChapter/Label").set_text(str(LOAD.menuText[5]))
	get_node("SelectChapter/RetourChapitres").set_text(str(LOAD.optionsText[3]))

	# Textes OPTIONS
	get_node("Options/VBox/Reset").set_text(str(LOAD.optionsText[0]))
	get_node("Options/VBox/Credits").set_text(str(LOAD.optionsText[1]))
	#get_node("Options/VBox/Retour").set_text(str(LOAD.optionsText[3]))
	get_node("Options/VBox/Site").set_text(str(LOAD.optionsText[4]))
	addWeb = str(LOAD.optionsText[5])
	
	# Textes CREDITS
	get_node("Credits/ScrollContainer/RichTextLabel").set_text(str(LOAD.creditsText[0]))
	get_node("Credits/Label").set_text(str(LOAD.optionsText[1]))
	get_node("Credits/RetourCredits").set_text(str(LOAD.optionsText[3]))

	soundOptions()
	system_arrow()

func button_pressed(i,y):
	LOAD.scenarioFile = i
	LOAD.loadChapter = y
	LOAD._load_chapter()


func _on_Start_pressed():
	LOAD.scenarioFile = LOAD.lang._Language.Config.scenarioFile[LOAD.actualChapter-1]
	LOAD.loadChapter = LOAD.actualChapter
	LOAD._load_chapter()
	#get_node("SelectChapter").popup()
	#for i in LOAD.lang._Language.Config.scenarioFile:
	#	y = y+1
	#	button = get_node("SelectChapter/VBoxContainer/Button")
	#	newButton = button.duplicate()
	#	get_node("SelectChapter/VBoxContainer").add_child(newButton)
	#	newButton.show()
	#	newButton.set_disabled(y > LOAD.chapterSave)
	#	newButton.set_name(str("Button",i))
	#	newButton.set_text(str(LOAD.menuText[4]," ",y))
	#	newButton.connect("pressed", self, "button_pressed", [i,y])
		
func soundOptions():
	if LOAD.MusicButton == 1:
		get_node("Options/VBox/HBox0/MusicButton").set_modulate(Color("#2873f3"))
		if get_node("SampleBKGmenu").is_active() == 0:
			get_node("SampleBKGmenu").play("Bkg_main_menu")
	elif LOAD.MusicButton == 0:
		get_node("Options/VBox/HBox0/MusicButton").set_modulate(Color("#898989"))
		if get_node("SampleBKGmenu").is_active() == 1:
			get_node("SampleBKGmenu").stop_all()
	if LOAD.SoundButton == 1:
		get_node("Options/VBox/HBox0/SoundButton").set_modulate(Color("#2873f3"))
	elif LOAD.SoundButton == 0:
		get_node("Options/VBox/HBox0/SoundButton").set_modulate(Color("#898989"))
	return
	

func _on_Option_pressed():
	get_node("Options").popup()

func _on_Credits_pressed():
	get_node("Options").hide()
	get_node("Credits").popup()

func _on_Retour_pressed():
	get_node("Options").hide()


func _on_Youtube_pressed():
	OS.shell_open("https://www.youtube.com/channel/UCi_4enQ0P4U7XKdcP9340cg")


func _on_Twitter_pressed():
	OS.shell_open("https://twitter.com/ChroniquesTalos")


func _on_Facebook_pressed():
	OS.shell_open("https://www.facebook.com/chroniquesdetalos/")


func _on_Site_pressed():
	OS.shell_open(addWeb)


func _on_Reset_pressed():
	Directory.new().remove("user://saveglobal.json")
	get_tree().reload_current_scene()
	LOAD._ready()

func _on_Quitter_pressed():
	get_tree().quit()

func _on_RetourCredits_pressed():
	get_node("Credits").hide()


func _on_RetourChapitres_pressed():
	for i in LOAD.lang._Language.Config.scenarioFile:
		button = get_node(str("SelectChapter/VBoxContainer/Button",i))
		button.queue_free()
		y = 0
	get_node("SelectChapter").hide()

func _on_MusicButton_pressed():
	if LOAD.MusicButton == 1:
		LOAD.MusicButton = 0
		soundOptions()
	elif LOAD.MusicButton == 0:
		LOAD.MusicButton = 1
		soundOptions()
	LOAD.saveGlobal()
	return
	
	
func _on_SoundButton_pressed():
	if LOAD.SoundButton == 1:
		LOAD.SoundButton = 0
		soundOptions()
	elif LOAD.SoundButton == 0:
		LOAD.SoundButton = 1
		soundOptions()
	LOAD.saveGlobal()
	return

func _on_RightArrow_pressed():
	print("RIGHT ARROW PRESSED")
	LOAD.actualChapter += 1
	LOAD.saveGlobal()
	system_arrow()
	LOAD.tween = get_node("Tween")
	LOAD.targetNode = get_node("Chapitre")
	LOAD.tweenType = "visibility/self_opacity"
	LOAD.tweenStart = 1
	LOAD.tweenEnd = 0
	LOAD.tweenTime = 2.0
	LOAD.system_tween()
	LOAD.tween = get_node("Tween")
	LOAD.targetNode = get_node("Sprite")
	LOAD.tweenType = "transform/pos"
	position = get_node("Sprite").get_pos().x
	LOAD.tweenStart = Vector2(position,1)
	LOAD.tweenEnd = Vector2(position-1080,1)
	LOAD.tweenTime = 0.5
	LOAD.system_tween()
	get_node("Chapitre").set_text(str(LOAD.menuText[4]," ",LOAD.actualChapter))
	LOAD.tween = get_node("Tween")
	LOAD.targetNode = get_node("Chapitre")
	LOAD.tweenType = "visibility/self_opacity"
	LOAD.tweenStart = 0
	LOAD.tweenEnd = 1
	LOAD.tweenTime = 2.0
	LOAD.system_tween()



func _on_LeftArrow_pressed():
	print("LEFT ARROW PRESSED")
	LOAD.actualChapter -= 1
	LOAD.saveGlobal()
	system_arrow()
	LOAD.tween = get_node("Tween")
	LOAD.targetNode = get_node("Chapitre")
	LOAD.tweenType = "visibility/self_opacity"
	LOAD.tweenStart = 1
	LOAD.tweenEnd = 0
	LOAD.tweenTime = 2.0
	LOAD.system_tween()
	LOAD.tween = get_node("Tween")
	LOAD.targetNode = get_node("Sprite")
	LOAD.tweenType = "transform/pos"
	position = get_node("Sprite").get_pos().x
	LOAD.tweenStart = Vector2(position,1)
	LOAD.tweenEnd = Vector2(position+1080,1)
	LOAD.tweenTime = 0.5
	LOAD.system_tween()
	get_node("Chapitre").set_text(str(LOAD.menuText[4]," ",LOAD.actualChapter))
	LOAD.tween = get_node("Tween")
	LOAD.targetNode = get_node("Chapitre")
	LOAD.tweenType = "visibility/self_opacity"
	LOAD.tweenStart = 0
	LOAD.tweenEnd = 1
	LOAD.tweenTime = 2.0
	LOAD.system_tween()
	
func system_arrow():
	if LOAD.actualChapter == 1:
		get_node("LeftArrow").hide()
		get_node("LeftArrow").set("focus/ignore_mouse", true)
	else:
		get_node("LeftArrow").show()
		get_node("LeftArrow").set("focus/ignore_mouse", false)

	if LOAD.actualChapter == LOAD.chapterNumber:
		get_node("RightArrow").hide()
		get_node("RightArrow").set("focus/ignore_mouse", true)
	else:
		get_node("RightArrow").show()
		get_node("RightArrow").set("focus/ignore_mouse", false)