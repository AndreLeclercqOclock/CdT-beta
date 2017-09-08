# Crédits #
# Script par LEIFER KOPF // leifer.kopf@gmail.com
# Scénario par NOOTILUS //
# Disclaimer : L'ensemble du contenu de ce document est la propriété de GalaaDScript, il ne peut être utilisé, même partiellement sans accord préalable de GalaaDScript (Filliale du groupe AE-Com).
# version : 0.22

extends Control

var dict = {}
var currentDial = "dial001"
var timer = null
var time_delay = null
var write = false

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
	
	# Timer
	time_delay = dict._Dialogues[currentDial].time
	timer = get_node("Timer")
	timer.set_wait_time(time_delay)
	timer.start()

func _on_Timer_timeout():
	print("timer")
	write = true

	# Gestion des dialogues de ref 1 [DIALOGUES]
	while currentDial in dict._Dialogues and dict._Dialogues[currentDial].ref == 1 and write == true :
		print("Dialogues")
		get_node("Dialogues").push_align(0)
		get_node("Dialogues").add_text(str("\n [",currentDial,"] : ",dict._Dialogues[currentDial].content))
		currentDial = dict._Dialogues[currentDial].next
		write = false
		start()
	
	# Gestion des dialogues de ref 2 [REPONSES CHOIX MULTIPLES]
	if dict._Dialogues[currentDial].ref == 2 :
		print("Réponses choix multiples")
		for i in range(dict._Dialogues[currentDial].content.size()):
			get_node(str("Bouton",i)).set_text(str("[",currentDial,"] : ",dict._Dialogues[currentDial].content[i]))
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
	for i in range(4):
		print("Suppression bouton")
		get_node(str("Bouton",i)).set_text("")
		get_node(str("Bouton",i)).set_ignore_mouse(true)
		get_node(str("Bouton",i)).set_flat(true)


func _on_TextEdit_text_entered( text ):
	if get_node("TextEdit").get_text() == dict._Dialogues[currentDial].content[0]:
		get_node("Dialogues").push_align(2)
		get_node("Dialogues").add_text(str("\n[",currentDial,"] : ",dict._Dialogues[currentDial].content[0]))
		currentDial = dict._Dialogues[currentDial].next[0]
		get_node("TextEdit").hide()
		start()
	else:
		currentDial = dict._Dialogues[currentDial].next[1]
		start()
		
		
