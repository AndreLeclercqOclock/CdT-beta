# Crédits #
# Script par LEIFER KOPF // leifer.kopf@gmail.com
# Scénario par NOOTILUS //
# Disclaimer : L'ensemble du contenu de ce document est la propriété de GalaaDScript, il ne peut être utilisé, même partiellement sans accord préalable de GalaaDScript (Filliale du groupe AE-Com).
# version : 0.22

extends Control

var dict = {}
var currentDial = "dial001"


func _ready():
	print("ready")
	start()
	
func start():
	print("start")
	
	# Ouverture / Parse / Fermeture du fichier JSON
	var file = File.new()
	file.open("res://json/credit.json", file.READ)
	dict.parse_json(file.get_as_text())
	file.close()
	
	
	# Gestion des dialogues de ref 1 [DIALOGUES]
	while currentDial in dict._Dialogues and dict._Dialogues[currentDial].ref == 1 :
		print("Dialogues")
		get_node("Dialogues").push_align(0)
		get_node("Dialogues").add_text(str("\n [",currentDial,"] : ",dict._Dialogues[currentDial].content))
		currentDial = dict._Dialogues[currentDial].next
	
	
	# Gestion des dialogues de ref 2 [REPONSES]
	for i in range(dict._Dialogues[currentDial].content.size()):
		print("Réponses choix multiples")
		get_node(str("Bouton",i)).set_text(str("[",currentDial,"] : ",dict._Dialogues[currentDial].content[i]))
		get_node(str("Bouton",i)).set_ignore_mouse(false)
		get_node(str("Bouton",i)).set_flat(false)
	
	
	# Gestion des boutons de choix multipes
	# BOUTON 0
func _on_Bouton0_pressed():
	print("Bouton 0")
	get_node("Dialogues").push_align(2)
	get_node("Dialogues").add_text(str("\n[",currentDial,"] : ",dict._Dialogues[currentDial].content[0]))
	currentDial = dict._Dialogues[currentDial].next[0]
	clean()
	start()
	
	# BOUTON 1
func _on_Bouton1_pressed():
	print("Bouton 1")
	get_node("Dialogues").push_align(2)
	get_node("Dialogues").add_text(str("\n[",currentDial,"] : ",dict._Dialogues[currentDial].content[1]))
	currentDial = dict._Dialogues[currentDial].next[1]
	clean()
	start()
	
	# BOUTON 2
func _on_Bouton2_pressed():
	print("Bouton 2")
	get_node("Dialogues").push_align(2)
	get_node("Dialogues").add_text(str("\n [",currentDial,"] : ",dict._Dialogues[currentDial].content[2]))
	currentDial = dict._Dialogues[currentDial].next[2]
	clean()
	start()
	
	# BOUTON 3
func _on_Bouton3_pressed():
	print("Bouton 3")
	get_node("Dialogues").push_align(2)
	get_node("Dialogues").add_text(str("\n [",currentDial,"] : ",dict._Dialogues[currentDial].content[3]))
	currentDial = dict._Dialogues[currentDial].next[3]
	clean()
	start()
	
	# Nettoyage des boutons inutiles
func clean():
	for i in range(3):
		print("Suppression bouton")
		get_node(str("Bouton",i)).set_text("")
		get_node(str("Bouton",i)).set_ignore_mouse(true)
		get_node(str("Bouton",i)).set_flat(true)


