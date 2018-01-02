extends Control

var button = null
var buttonCheck = null
var newButton = null
var newLabel = null
var y = 0
var addWeb = null
var imgTexture = null

func _ready():
	if LOAD.fileExists == false:
		get_node("Start/Label").set_text(str(LOAD.menuText[0]))
	else:
		get_node("Start/Label").set_text(str(LOAD.menuText[1]))

	get_node("Option/Label1").set_text(str(LOAD.menuText[2]))
	get_node("Quitter/Label2").set_text(str(LOAD.menuText[3]))
		

	# Textes SelectChapter
	get_node("SelectChapter/Label").set_text(str(LOAD.menuText[5]))
	get_node("SelectChapter/RetourChapitres/Label").set_text(str(LOAD.optionsText[3]))

	# Textes OPTIONS
	get_node("Options/VBox/Reset/Label").set_text(str(LOAD.optionsText[0]))
	get_node("Options/VBox/Credits/Label").set_text(str(LOAD.optionsText[1]))
	get_node("Options/VBox/Retour/Label").set_text(str(LOAD.optionsText[3]))
	get_node("Options/VBox/Site/Label").set_text(str(LOAD.optionsText[4]))
	addWeb = str(LOAD.optionsText[5])
	
	# Textes CREDITS
	get_node("Credits/ScrollContainer/RichTextLabel").set_text(str(LOAD.creditsText[0]))
	get_node("Credits/Label").set_text(str(LOAD.optionsText[1]))
	get_node("Credits/RetourCredits/Label").set_text(str(LOAD.optionsText[3]))

	soundOptions()

func button_pressed(i,y):
	LOAD.scenarioFile = i
	LOAD.loadChapter = y
	LOAD._load_chapter()


func _on_Start_pressed():
	#get_tree().change_scene("res://scn/base.tscn.xml")
	get_node("SelectChapter").popup()
	for i in LOAD.lang._Language.Config.scenarioFile:
		y = y+1
		button = get_node("SelectChapter/VBoxContainer/Button")
		newButton = button.duplicate()
		get_node("SelectChapter/VBoxContainer").add_child(newButton)
		newButton.show()
		newButton.set_disabled(y > LOAD.chapterSave)
		newButton.set_name(str("Button",i))
		newLabel = newButton.get_node("Label")
		newLabel.set_text(str(LOAD.menuText[4]," ",y))
		newButton.connect("pressed", self, "button_pressed", [i,y])
		
func soundOptions():
	if LOAD.MusicButton == 1:
		imgTexture = load("res://img/music_ON.png")
		get_node("MusicButton").set("textures/normal", imgTexture)
		if get_node("SampleBKGmenu").is_active() == 0:
			get_node("SampleBKGmenu").play("Bkg_main_menu") 
	elif LOAD.MusicButton == 0:
		imgTexture = load("res://img/music_OFF.png")
		get_node("MusicButton").set("textures/normal", imgTexture)
		if get_node("SampleBKGmenu").is_active() == 1:
			get_node("SampleBKGmenu").stop_all()
	if LOAD.SoundButton == 1:
		imgTexture = load("res://img/sound_ON.png")
		get_node("SoundButton").set("textures/normal", imgTexture)
	elif LOAD.SoundButton == 0:
		imgTexture = load("res://img/sound_OFF.png")
		get_node("SoundButton").set("textures/normal", imgTexture)
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

