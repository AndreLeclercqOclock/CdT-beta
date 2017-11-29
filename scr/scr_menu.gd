extends Control

var button = null
var buttonCheck = null

func _ready():
	if LOAD.fileExists == false:
		get_node("Start/Label").set_text(str(LOAD.menuText[0]))
	else:
		get_node("Start/Label").set_text(str(LOAD.menuText[1]))

	get_node("Option/Label1").set_text(str(LOAD.menuText[2]))
	get_node("Credits/Label2").set_text(str(LOAD.menuText[3]))

	for i in LOAD.lang._Language.Config.scenarioFile:
		buttonCheck = get_node("SelectChapter/VboxContainer/Button",i)
		buttonCheck.connect("toggled", self, "button_toggled",[buttonCheck])

func button_pressed(i):
	LOAD.scenarioFile = LOAD.lang._Language.Config.scenarioFile[i]


func _on_Start_pressed():
	#get_tree().change_scene("res://scn/base.tscn.xml")
	get_node("SelectChapter").popup()
	for i in LOAD.lang._Language.Config.scenarioFile:
		button = get_node("SelectChapter/VboxContainer/Button")
		button.duplicate()
		button.set_name(str("Button",i))
		button = get_node(str("SelectChapter/VboxContainer/Button",i))
		get_node(str("SelectChapter/VboxContainer/Button",i,"Label")).set_text(str(LOAD.menuText[4]," ",i+1))
		button.show()
		button.connect("pressed", self, "button_pressed", [i])
	

func _on_Option_pressed():
	get_tree().change_scene("res://scn/option.tscn")
	GLOBAL.backoption = "res://scn/menu.tscn"


func _on_Credits_pressed():
	get_tree().change_scene("res://scn/credits.tscn")
	GLOBAL.backcredit = "res://scn/menu.tscn"
