# Crédits #
# Script par LEIFER KOPF // leifer.kopf@gmail.com
# Scénario par NOOTILUS //
# Disclaimer : L'ensemble du contenu de ce document est la propriété de GalaaDScript, il ne peut être utilisé, même partiellement sans accord préalable de GalaaDScript (Filliale du groupe AE-Com).
# version : 0.45

extends Control

# Déclaration de Variables
var dict = {}
var currentDial = "dial001"
var timer = null
var time_delay = 1
var write = false
var wait = false
var image = null

func _ready():
	print("ready")
	start()
	
func start():
	print("start")
	
# Ouverture / Parse / Fermeture du fichier JSON
	var file = File.new()
	file.open("res://json/dial_fr.json", file.READ)
	dict.parse_json(file.get_as_text())
	file.close()
	timer()
	
# Timer
func timer():
	timer = get_node("Timer")
	timer.set_wait_time(time_delay)
	timer.start()
	

# A la fin du timer
func _on_Timer_timeout():
	print("timer")
	if wait == false:
		wait = true
		start()
	elif wait and write == false:
		write = true
		wait = false
	get_node("Status").clear()
	
# Affiche un texte quand l'interlocuteur écrit
	if dict._Dialogues[currentDial].ref == 1 and wait:
		get_node("Status").set_text(str(dict._Dialogues.name.name," écrit un message"))
		time_delay = 2
	
	
# Gestion des dialogues de ref 1 [DIALOGUES]
	while currentDial in dict._Dialogues and dict._Dialogues[currentDial].ref == 1 and write :
		print("Dialogues")
		get_node("Dialogues").set_scroll_follow(true)
		get_node("Dialogues").newline()
		get_node("Dialogues").push_align(0)
		get_node("Dialogues").add_text(str(dict._Dialogues.name.name," : ",dict._Dialogues[currentDial].content))
		currentDial = dict._Dialogues[currentDial].next
		time_delay = dict._Dialogues[currentDial].time
		write = false
		start()

# Gestion des images dialogues de ref 4 [IMAGES]
	if dict._Dialogues[currentDial].ref == 4 and write:
		image = load(str("res://img/",dict._Dialogues[currentDial].content))
		get_node("Dialogues").newline()
		get_node("Dialogues").push_align(0)
		get_node("Dialogues").add_image(image)
		currentDial = dict._Dialogues[currentDial].next
		time_delay = dict._Dialogues[currentDial].time
		write = false
		start()
	
# Gestion des dialogues de ref 2 [REPONSES CHOIX MULTIPLES]
	if dict._Dialogues[currentDial].ref == 2 :
		print("Réponses choix multiples")
		for i in range(dict._Dialogues[currentDial].content.size()):
			get_node("Dialogues").newline()
			get_node(str("Bouton",i)).set_text(str(dict._Dialogues[currentDial].content[i]))
			get_node(str("Bouton",i)).set_ignore_mouse(false)
			get_node(str("Bouton",i)).set_flat(false)
		timer.stop()
	
	
# Gestion des dialogues de ref 3 [REPONSES VIA TEXTE PRECIS]
	if dict._Dialogues[currentDial].ref == 3:
		print("Réponses via texte")
		get_node("TextEdit").show()
		get_node("TextEdit").clear()
		timer.stop()
	
# Gestion des boutons de choix multipes
# BOUTON 0
func _on_Bouton0_pressed():
	print("Bouton 0")
	get_node("Dialogues").push_align(2)
	get_node("Dialogues").add_text(str("Moi : ",dict._Dialogues[currentDial].content[0]))
	currentDial = dict._Dialogues[currentDial].next[0]
	time_delay = dict._Dialogues[currentDial].time
	clean()
	start()
	
# BOUTON 1
func _on_Bouton1_pressed():
	print("Bouton 1")
	get_node("Dialogues").push_align(2)
	get_node("Dialogues").add_text(str("Moi : ",dict._Dialogues[currentDial].content[1]))
	currentDial = dict._Dialogues[currentDial].next[1]
	time_delay = dict._Dialogues[currentDial].time
	clean()
	start()
	
# BOUTON 2
func _on_Bouton2_pressed():
	print("Bouton 2")
	get_node("Dialogues").push_align(2)
	get_node("Dialogues").add_text(str("Moi : ",dict._Dialogues[currentDial].content[2]))
	currentDial = dict._Dialogues[currentDial].next[2]
	time_delay = dict._Dialogues[currentDial].time
	clean()
	start()
	
# BOUTON 3
func _on_Bouton3_pressed():
	print("Bouton 3")
	get_node("Dialogues").push_align(2)
	get_node("Dialogues").add_text(str("Moi : ",dict._Dialogues[currentDial].content[3]))
	currentDial = dict._Dialogues[currentDial].next[3]
	time_delay = dict._Dialogues[currentDial].time
	clean()
	start()
	
# Nettoyage des boutons inutiles
func clean():
	for i in range(4):
		print("Suppression bouton")
		get_node(str("Bouton",i)).set_text("")
		get_node(str("Bouton",i)).set_ignore_mouse(true)
		get_node(str("Bouton",i)).set_flat(true)

# Boite de dialogue pour écrire la réponse demandée.
func _on_TextEdit_text_entered( text ):
	if get_node("TextEdit").get_text() == dict._Dialogues[currentDial].content[0]:
		get_node("Dialogues").push_align(2)
		get_node("Dialogues").add_text(str("Moi : ",dict._Dialogues[currentDial].content[0]))
		currentDial = dict._Dialogues[currentDial].next[0]
		time_delay = dict._Dialogues[currentDial].time
		get_node("TextEdit").hide()
		start()
	else:
		currentDial = dict._Dialogues[currentDial].next[1]
		time_delay = dict._Dialogues[currentDial].time
		start()
		
		
