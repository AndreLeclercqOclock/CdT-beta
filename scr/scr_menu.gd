extends Control

func _ready():
	if LOAD.fileExists == false:
		get_node("Start/Label").set_text(str(LOAD.menuText[0]))
	else:
		get_node("Start/Label").set_text(str(LOAD.menuText[1]))

	get_node("Option/Label1").set_text(str(LOAD.menuText[2]))
	get_node("Credits/Label2").set_text(str(LOAD.menuText[3]))

func _on_Start_pressed():
	get_tree().change_scene("res://scn/base.tscn.xml")


func _on_Option_pressed():
	get_tree().change_scene("res://scn/option.tscn")
	GLOBAL.backoption = "res://scn/menu.tscn"


func _on_Credits_pressed():
	get_tree().change_scene("res://scn/credits.tscn")
	GLOBAL.backcredit = "res://scn/menu.tscn"
