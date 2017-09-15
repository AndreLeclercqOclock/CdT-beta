# Crédits #
# Script par LEIFER KOPF // leifer.kopf@gmail.com
# Scénario par VINCENT CORLAIX  // vcorlaix@nootilus.com
# Disclaimer : L'ensemble du contenu de ce document est la propriété de GalaaDScript, il ne peut être utilisé, même partiellement sans accord préalable de GalaaDScript (Filliale du groupe AE-Com).
# version : 0.58

extends Control

# Déclaration de Variables
var dict = {}
var currentDial = "dial001"
var timer = null
var time_delay = 1
var image = null
var video = null
var content = null
var wait = false
var dial = []
var size = null

# Lancement du script en jeu
func _ready():
	start()

# Fonction ou reboucle le script quand il repart du début
func start():

# Ouverture / Parse / Fermeture du fichier JSON
	var file = File.new()
	file.open("res://json/protoTest_fr.json", file.READ)
	dict.parse_json(file.get_as_text())
	file.close()

# Initialisation du Timer
	timer = get_node("Timer")
	timer.set_wait_time(time_delay)

									## DIALOGUES ##
# Gestion des dialogues de ref 1 [DIALOGUES]
	if dict._Dialogues[currentDial].ref == 1 :
		get_node("Dialogues").set_scroll_follow(true)
		get_node("Dialogues").push_align(0)
		for i in range(dict._Dialogues[currentDial].content.size()):

# Affiche le status "Ecrit un message"
			get_node("Status").add_text(str(dict._Dialogues.name.name," écrit un message"))
			dial = [dict._Dialogues[currentDial].content[i]]
			size = (dial[0].length())/20
			if size <= 0:
				size = 0.5
			time_delay = size
			timer.set_wait_time(time_delay)
			timer.start()
			yield(get_node("Timer"), "timeout")
			get_node("Status").clear()

# Ecrit la ligne de dialogue
			get_node("Dialogues").newline()
			get_node("Dialogues").add_text(str(dict._Dialogues.name.name," : ",dict._Dialogues[currentDial].content[i]))
			time_delay = dict._Dialogues[currentDial].time
			timer.set_wait_time(time_delay)
			timer.start()
			yield(get_node("Timer"), "timeout")
		currentDial = dict._Dialogues[currentDial].next
		time_delay = dict._Dialogues[currentDial].time
		timer.set_wait_time(time_delay)
		timer.start()
		yield(get_node("Timer"), "timeout")
		start()


									## REPONSES ##
# Gestion des dialogues de ref 2 [REPONSES CHOIX MULTIPLES]
	if dict._Dialogues[currentDial].ref == 2 :
		for i in range(dict._Dialogues[currentDial].content.size()):
			get_node(str("Bouton",i)).set_text(str(dict._Dialogues[currentDial].button[i]))
			get_node(str("Bouton",i)).set_ignore_mouse(false)
			get_node(str("Bouton",i)).set_flat(false)
		timer.stop()


# Gestion des dialogues de ref 3 [REPONSES VIA TEXTE PRECIS]
	if dict._Dialogues[currentDial].ref == 3:
		get_node("TextEdit").show()
		get_node("TextEdit").clear()
		timer.stop()

									## MEDIAS ##
# Gestion des images dialogues de ref 4 [IMAGES]
	if dict._Dialogues[currentDial].ref == 4:
		image = load(str("res://img/",dict._Dialogues[currentDial].content))
		get_node("Dialogues").newline()
		get_node("Dialogues").push_align(0)
		get_node("Dialogues").add_image(image)
		currentDial = dict._Dialogues[currentDial].next
		time_delay = dict._Dialogues[currentDial].time
		start()



# Gestion des vidéos dialogues de ref 5 [VIDEOS]
	if dict._Dialogues[currentDial].ref == 5:
		if wait == false:
			get_node("VideoPlayer").show()
			video = load("res://vid/sample.ogv")
			get_node("VideoPlayer").set_stream(video)
			get_node("VideoPlayer").play()
			print("PLAY")
			yield(get_node("VideoPlayer"),"stopped")
			print("STOP")
			get_node("VideoPlayer").hide()
			currentDial = dict._Dialogues[currentDial].next
			time_delay = dict._Dialogues[currentDial].time
			start()


										## BOUTONS REPONSES ##
# Gestion des boutons de choix multipes
# BOUTON 0
func _on_Bouton0_pressed():
	clean()
	get_node("Dialogues").push_align(2)
	get_node("Dialogues").newline()
	get_node("Dialogues").add_text(str("Moi : ",dict._Dialogues[currentDial].content[0]))
	currentDial = dict._Dialogues[currentDial].next[0]
	time_delay = dict._Dialogues[currentDial].time
	timer.set_wait_time(time_delay)
	timer.start()
	yield(get_node("Timer"), "timeout")
	start()

# BOUTON 1
func _on_Bouton1_pressed():
	clean()
	get_node("Dialogues").push_align(2)
	get_node("Dialogues").newline()
	get_node("Dialogues").add_text(str("Moi : ",dict._Dialogues[currentDial].content[1]))
	currentDial = dict._Dialogues[currentDial].next[1]
	time_delay = dict._Dialogues[currentDial].time
	timer.set_wait_time(time_delay)
	timer.start()
	yield(get_node("Timer"), "timeout")
	start()

# BOUTON 2
func _on_Bouton2_pressed():
	clean()
	get_node("Dialogues").push_align(2)
	get_node("Dialogues").newline()
	get_node("Dialogues").add_text(str("Moi : ",dict._Dialogues[currentDial].content[2]))
	currentDial = dict._Dialogues[currentDial].next[2]
	time_delay = dict._Dialogues[currentDial].time
	timer.set_wait_time(time_delay)
	timer.start()
	yield(get_node("Timer"), "timeout")
	start()

# BOUTON 3
func _on_Bouton3_pressed():
	get_node("Dialogues").push_align(2)
	get_node("Dialogues").newline()
	get_node("Dialogues").add_text(str("Moi : ",dict._Dialogues[currentDial].content[3]))
	currentDial = dict._Dialogues[currentDial].next[3]
	time_delay = dict._Dialogues[currentDial].time
	timer.set_wait_time(time_delay)
	timer.start()
	yield(get_node("Timer"), "timeout")
	start()


# Nettoyage des boutons inutiles
func clean():
	for i in range(4):
		get_node(str("Bouton",i)).set_text("")
		get_node(str("Bouton",i)).set_ignore_mouse(true)
		get_node(str("Bouton",i)).set_flat(true)

									## BOITE DE DIALOGUE REPONSES ECRITE ##
# Boite de dialogue pour écrire la réponse demandée.
func _on_TextEdit_text_entered( text ):
	if get_node("TextEdit").get_text() == dict._Dialogues[currentDial].content[0]:
		get_node("Dialogues").push_align(2)
		get_node("Dialogues").add_text(str("Moi : ",dict._Dialogues[currentDial].content[0]))
		currentDial = dict._Dialogues[currentDial].next[0]
		time_delay = dict._Dialogues[currentDial].time
		timer.set_wait_time(time_delay)
		get_node("TextEdit").hide()
		start()
	else:
		currentDial = dict._Dialogues[currentDial].next[1]
		time_delay = dict._Dialogues[currentDial].time
		timer.set_wait_time(time_delay)
		start()
