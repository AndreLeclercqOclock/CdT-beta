extends Control

func _ready():
	get_node("Reset/Label1").set_text(str(LOAD.optionsText[0]))
	get_node("Credits/Label").set_text(str(LOAD.optionsText[1]))
	get_node("Retour/Label").set_text(str(LOAD.optionsText[2]))
	get_node("Quitter/Label").set_text(str(LOAD.optionsText[3]))

func _on_Credits_pressed():
	get_tree().change_scene("res://scn/credits.tscn")
	GLOBAL.backcredit = "res://scn/option.tscn"


func _on_Retour_pressed():
	get_tree().change_scene(GLOBAL.backoption)
	LOAD._ready()


func _on_Youtube_pressed():
	OS.shell_open("https://www.youtube.com/channel/UCi_4enQ0P4U7XKdcP9340cg")


func _on_Twitter_pressed():
	OS.shell_open("https://twitter.com/ChroniquesTalos")


func _on_Facebook_pressed():
	OS.shell_open("https://www.facebook.com/chroniquesdetalos/")


func _on_Site_pressed():
	OS.shell_open("http://www.chroniquesdetalos.com")


func _on_Reset_pressed():
	Directory.new().remove("user://saveglobal.json")
	get_tree().reload_current_scene()
	LOAD._ready()

func _on_Quitter_pressed():
	get_tree().change_scene("res://scn/base.tscn")
	get_tree().quit()