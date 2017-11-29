extends Control

var button = null
var buttonCheck = null
var newButton = null
var newLabel = null
var y = 0

func _ready():
	if LOAD.fileExists == false:
		get_node("Start/Label").set_text(str(LOAD.menuText[0]))
	else:
		get_node("Start/Label").set_text(str(LOAD.menuText[1]))

	get_node("Option/Label1").set_text(str(LOAD.menuText[2]))
	get_node("Credits/Label2").set_text(str(LOAD.menuText[3]))
		
		

func button_pressed(i):
	LOAD.scenarioFile = str("LOAD.lang._Language.Config.scenarioFile[i]")
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
		newButton.set_name(str("Button",i))
		newLabel = newButton.get_node("Label")
		newLabel.set_text(str(LOAD.menuText[4]," ",y))
		newButton.connect("pressed", self, "button_pressed", [i])
		
		
	

func _on_Option_pressed():
	get_tree().change_scene("res://scn/option.tscn")
	GLOBAL.backoption = "res://scn/menu.tscn"


func _on_Credits_pressed():
	get_tree().change_scene("res://scn/credits.tscn")
	GLOBAL.backcredit = "res://scn/menu.tscn"
