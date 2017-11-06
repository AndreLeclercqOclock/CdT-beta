extends Control


func _on_Credits_pressed():
	get_tree().change_scene("res://scn/credits.tscn")
	GLOBAL.backcredit = "res://scn/option.tscn"


func _on_Retour_pressed():
	get_tree().change_scene(GLOBAL.backoption)


func _on_Youtube_pressed():
	OS.shell_open("https://www.youtube.com/channel/UCi_4enQ0P4U7XKdcP9340cg")


func _on_Twitter_pressed():
	OS.shell_open("https://twitter.com/ChroniquesTalos")


func _on_Facebook_pressed():
	OS.shell_open("https://www.facebook.com/chroniquesdetalos/")


func _on_Site_pressed():
	OS.shell_open("http://www.chroniquesdetalos.com")


func _on_Reset_pressed():
	Directory.new().remove("user://savelogs.json")
	get_tree().reload_current_scene()


func _on_Quitter_pressed():
	get_tree().change_scene("res://scn/base.tscn.xml")
	get_tree().quit()