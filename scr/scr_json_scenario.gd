# Crédits #
# Script par LEIFER KOPF // leifer.kopf@gmail.com
# Scénario par VINCENT CORLAIX  // vcorlaix@nootilus.com
# Disclaimer : L'ensemble du contenu de ce document est la propriété de GalaaDScript, il ne peut être utilisé, même partiellement sans accord préalable de GalaaDScript (Filliale du groupe AE-Com).
# version : 0.253

extends Control

# Déclaration de Variables
#var dict = {}
var save = {}
var currentDial = null
var timer = null
var time_delay = 1
var content = null
var dial = []
var size = null
var scenarioFile = null
var version = null
var stateSave = null
var data = null
var dataDial = null
var dataRep = null
var firstDial = null
var currentRep = null
var currentTime = null
var vscroll = 50
var saveDial = []
var saveRep = []
var saveTime = []
var labelH = null
var hourIG = "0"
var minuteIG = "0"
var secondIG = "0"
var saveNextTime = []
var dataNextTime = null
#var currentNextTime = 0
var unixTime = OS.get_unix_time()
var timeIG = null
var calcultime = 0
var timezone = 0
var realtime = 0


# Initialisation des bases du script
func _ready():
	print("Crédits")
	print("Script par LEIFER KOPF // leifer.kopf@gmail.com")
	print("Scénario par VINCENT CORLAIX  // vcorlaix@nootilus.com")
	print("Disclaimer : L'ensemble du contenu de ce document est la propriété de GalaaDScript, il ne peut être utilisé,	même partiellement sans accord préalable de GalaaDScript (Filliale du groupe AE-Com).")
	print("...................................................................................")
	print("#### LANCEMENT DU JEU ####")


# Initialisation du Timer
	print("Initialitation du Timer")
	timer = get_node("Timer")
	timer.set_wait_time(time_delay)

# Calcule time zone
	timezone = OS.get_datetime_from_unix_time(OS.get_unix_time()).hour
	realtime = OS.get_time().hour
	calcultime = realtime - timezone

# Affichage du nom de l'interlocuteur
	print("Affichage du nom")
	get_node("vbox/Top/Name").add_text(str(LOAD.dict._Dialogues.name.name))

# Affichage de la version de dev en JEU
	print("Affichage version en jeu")
	get_node("vbox/Top/version").set_text(str(LOAD.version))

	if LOAD.fileExists == false:
		start()

# Affichage de l'heure
	set_process(true)

func _process(delta):
	saveTime = OS.get_unix_time()
	system_time()
	# Affichage de l'heure
	get_node("vbox/Top/clock").set_text(timeIG)

	if LOAD.launch != 0 and LOAD.currentNextTime <= OS.get_unix_time():
		print("Fin du timer")
		LOAD.launch = 0
		start()



############################### DEBUT DU SCRIPT ###############################
# Fonction ou reboucle le script quand il repart du début
func start():
	print("Début du processus d'interpretation du JSON")
	status()


									## DIALOGUES ##
# Gestion des dialogues de ref 1 [DIALOGUES]

	if LOAD.dial.ref == 1 :
		print("#### DIALOGUES REF : 1 ####")
# Horodatage
		print("Horodatage")
		print("Création du label")
		saveTime = LOAD.currentNextTime
		system_time()
		var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelTime")
		var label = labelbase.duplicate()
		print("Configuration du label")
		label.set_name("LabelTime")
		get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
		label.show()
		print("Affiche l'heure")
		label.set_text(str(" - ",timeIG))
		var labelH = label.get_text()
# Auto Scroll
		print("Scroll")
		yield(get_tree(), "idle_frame")
		get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
		vscroll = vscroll+label.get_size().height+20
		get_node("vbox/Mid/DialBox").set_v_scroll(vscroll)
# Affichage Smoothie
		print("Affichage")
		var visible = 0
		time_delay = 0.05
		status()
		for i in range(9):
			label.set("visibility/opacity",visible)
			visible = visible + 0.10
			timer.set_wait_time(time_delay)
			timer.start()
			yield(get_node("Timer"), "timeout")

#Création de la node LABEL
		print("Traitement du Dialogue")
		for i in range(LOAD.content.size()):
# Calcule le nombre de charactères
			print("Calcule du nombre de charactère dans la phrase")
			dial = [LOAD.content[i]]
			size = (dial[0].length())/20
			print("Définition du temps d'écriture en secondes")
# Affiche le status "Ecrit un message"
			print("Création du label")
			var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelStat")
			var label = labelbase.duplicate()
			print("Configuration du label")
			label.set_name("LabelStatuts")
			get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
			label.show()
			print("Message système 'Ecrit un message'")
			#label.set_text("écrit un message...")
# Auto Scroll
			print("Scroll")
			yield(get_tree(), "idle_frame")
			get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
			vscroll = vscroll+10+20
			get_node("vbox/Mid/DialBox").set_v_scroll(vscroll)
# Affichage Smoothie
			print("Affichage")
			var visible = 0
			time_delay = 0.05
			status()
			for i in range(9):
				label.set("visibility/opacity",visible)
				visible = visible + 0.10
				timer.set_wait_time(time_delay)
				timer.start()
				yield(get_node("Timer"), "timeout")

# Fourchettes en fonction de la taille du texte.
		# Inférieur à 0 seconde
			if size <= 0:
				size = 0.5
		# Entre 0 & 2 secondes
			elif size > 0 and size <= 2:
				size = 1.5
		# Entre 2 & 5 secondes
			elif size > 2 and size <= 5:
				size = 3.5
		# Entre 5 & 10 secondes
			elif size > 5 and size <= 10:
				size = 5
		# Supérieur à 10 secondes
			elif size > 10:
				size = 7
			print("Temps d'écriture : ",size," seconde(s)")

# Lance le timer en fonction du nombre de char dans le content
			print("Lancement du timer",time_delay," seconde(s)")
			time_delay = size
			timer.set_wait_time(time_delay)
			timer.start()
			yield(get_node("Timer"), "timeout")
			print("Fin du timer")

# Temporisation courte entre le message système et le texte
			print("Temporisation : ",time_delay," seconde(s)")
			time_delay = 0.2
			timer.set_wait_time(time_delay)
			timer.start()
			yield(get_node("Timer"), "timeout")
			label.queue_free()
			print("Fin du timer")

# Ecrit la ligne de dialogue
			print("Création du label")
			var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelDial")
			var label = labelbase.duplicate()
			print("Configuration du label")
			label.set_name(str("label",i))
			var labelname = label.get_name()
			var labelbg = str("vbox/Mid/DialBox/VBoxMid/",labelname,"/LabelBG")
			get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
			label.show()
			print("Ecrit la ligne de dialogue : ",LOAD.content[i])
			label.set_text(str(" ",LOAD.content[i]))
# Ajustement de la taille du label
			var labelsize = label.get_line_count()
			print(str("Nombre de ligne :",labelsize))
			if labelsize == 1:
				label.set_size(Vector2(925,50))
				label.set("rect/min_size",Vector2(925,50))
				get_node(labelbg).set("transform/scale",Vector2(1,1))
			elif labelsize == 2:
				label.set_size(Vector2(925,110))
				label.set("rect/min_size",Vector2(925,110))
				get_node(labelbg).set("transform/scale",Vector2(1,2))
			elif labelsize == 3:
				label.set_size(Vector2(925,165))
				label.set("rect/min_size",Vector2(925,165))
				get_node(labelbg).set("transform/scale",Vector2(1,3))
			print(str("Taille du label :",label.get_size()))


# Auto Scroll
			print("Scroll")
			yield(get_tree(), "idle_frame")
			get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
			vscroll = vscroll+label.get_size().height+20
			get_node("vbox/Mid/DialBox").set_v_scroll(vscroll)
# Affichage Smoothie
			print("Affichage")
			var visible = 0
			for i in range(9):
				label.set("visibility/opacity",visible)
				visible = visible + 0.10
				time_delay = 0.05
				timer.set_wait_time(time_delay)
				timer.start()
				yield(get_node("Timer"), "timeout")

# Temporisation
			time_delay = 0.75
			print("Temporisation : ",time_delay," seconde(s)")
			timer.set_wait_time(time_delay)
			timer.start()
			yield(get_node("Timer"), "timeout")
			print("Fin du timer")
			print("Fin de la ligne")

# Clos la boucle et passe au next
		print("Fin du dialogue")
		LOAD.currentDial = LOAD.next
		LOAD.time_delay = LOAD.time
		print("Lancement du timer",time_delay," seconde(s)")
		LOAD.currentNextTime = OS.get_unix_time() + int(time_delay)
		LOAD.launch = 1

		#AUTO SAVE
		if LOAD.ref == 1 :
			print("Auto-Sauvegarde")
			unixTime = OS.get_unix_time()
			dataDial = currentDial
			dataRep = null
			dataNextTime = unixTime + int(time_delay)
			system_save()
		status()


									## REPONSES ##
# Gestion des dialogues de ref 2 [REPONSES CHOIX MULTIPLES]
	if LOAD.ref == 2 :
		print("#### DIALOGUES REF : 2 ####")
		print("Création de ",LOAD.content.size()," bouton(s)")
		for i in range(LOAD.content.size()):
			print("Création du bouton n°",LOAD.dial.button[i])
			get_node(str("vbox/Bot/VBoxBot/Bouton",i)).set_text(str(LOAD.dial.button[i]))
			get_node(str("vbox/Bot/VBoxBot/Bouton",i)).set_ignore_mouse(false)
			get_node(str("vbox/Bot/VBoxBot/Bouton",i)).set("visibility/visible",true)
		timer.stop()
		print("Fin de la création des boutons")


										## BOUTONS REPONSES ##
# Gestion des boutons de choix multipes
# BOUTON 0
func _on_Bouton0_pressed():
	get_node("vbox/Bot/VBoxBot/Bouton0/Sprite0").set_texture(load("res://img/bouton_clic.jpg"))
	print("Temporisation : ",time_delay," seconde(s)")
	timer.set_wait_time(0.1)
	timer.start()
	yield(get_node("Timer"), "timeout")
	print("Fin du timer")
	get_node("vbox/Bot/VBoxBot/Bouton0/Sprite0").set_texture(load("res://img/bouton_base.jpg"))
	clean()
	print("Bouton n°0 activé")
# AUTO SAVE
	dataDial = currentDial
	dataRep = 0
	dataNextTime = OS.get_unix_time() + int(time_delay)
	system_save()

# Ecrit la ligne de Dialogue
	print("Création du label")
	var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelRep")
	var label = labelbase.duplicate()
	print("Configuration du label")
	label.set_name(str("label",LOAD.dict._Dialogues[currentDial],0))
	get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
	label.show()
	print("Ecrit la ligne de dialogue : ",LOAD.dict._Dialogues[currentDial].content[0])
	label.set_text(str(LOAD.dict._Dialogues[currentDial].content[0]))

# Ajustement de la taille du label
	var labelsize = label.get_line_count()
	print(str("Nombre de ligne :",labelsize))
	if labelsize == 1:
		label.set_size(Vector2(925,55))
		label.set("rect/min_size",Vector2(925,55))
	elif labelsize == 2:
		label.set_size(Vector2(925,110))
		label.set("rect/min_size",Vector2(925,110))
	elif labelsize == 3:
		label.set_size(Vector2(925,165))
		label.set("rect/min_size",Vector2(925,165))
	print(str("Taille du label :",label.get_size()))

# Auto Scroll
	print("Scroll")
	yield(get_tree(), "idle_frame")
	get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
	vscroll = vscroll+label.get_size().height+20
	get_node("vbox/Mid/DialBox").set_v_scroll(vscroll)
# Affichage Smoothie
	print("Affichage")
	var visible = 0
	for i in range(9):
		label.set("visibility/self_opacity",visible)
		visible = visible + 0.10
		time_delay = 0.05
		timer.set_wait_time(time_delay)
		timer.start()
		yield(get_node("Timer"), "timeout")

	currentDial = LOAD.dict._Dialogues[currentDial].next[0]
	time_delay = LOAD.dict._Dialogues[currentDial].time
	#AUTO SAVE
	dataDial = currentDial
	dataRep = null
	dataNextTime = OS.get_unix_time() + int(time_delay)
	system_save()
	LOAD.launch = 1
	print("Lancement du timer",time_delay," seconde(s)")

# BOUTON 1
func _on_Bouton1_pressed():
	get_node("vbox/Bot/VBoxBot/Bouton1/Sprite1").set_texture(load("res://img/bouton_clic.jpg"))
	print("Temporisation : ",time_delay," seconde(s)")
	timer.set_wait_time(0.1)
	timer.start()
	yield(get_node("Timer"), "timeout")
	print("Fin du timer")
	get_node("vbox/Bot/VBoxBot/Bouton1/Sprite1").set_texture(load("res://img/bouton_base.jpg"))
	clean()
	print("Bouton n°1 activé")
# AUTO SAVE
	print("Auto-Sauvegarde")
	dataDial = currentDial
	dataRep = 1
	dataNextTime = OS.get_unix_time() + int(time_delay)
	system_save()

# Ecrit la ligne de Dialogue
	print("Création du label")
	var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelRep")
	var label = labelbase.duplicate()
	print("Configuration du label")
	label.set_name(str("label",LOAD.dict._Dialogues[currentDial],1))
	get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
	label.show()
	print("Ecrit la ligne de dialogue : ",LOAD.dict._Dialogues[currentDial].content[1])
	label.set_text(str(LOAD.dict._Dialogues[currentDial].content[1]))

# Ajustement de la taille du label
	var labelsize = label.get_line_count()
	print(str("Nombre de ligne :",labelsize))
	if labelsize == 1:
		label.set_size(Vector2(925,55))
		label.set("rect/min_size",Vector2(925,55))
	elif labelsize == 2:
		label.set_size(Vector2(925,110))
		label.set("rect/min_size",Vector2(925,110))
	elif labelsize == 3:
		label.set_size(Vector2(925,165))
		label.set("rect/min_size",Vector2(925,165))
	print(str("Taille du label :",label.get_size()))

# Auto Scroll
	print("Scroll")
	yield(get_tree(), "idle_frame")
	get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
	vscroll = vscroll+label.get_size().height+20
	get_node("vbox/Mid/DialBox").set_v_scroll(vscroll)
# Affichage Smoothie
	print("Affichage")
	var visible = 0
	for i in range(9):
		label.set("visibility/self_opacity",visible)
		visible = visible + 0.10
		time_delay = 0.05
		timer.set_wait_time(time_delay)
		timer.start()
		yield(get_node("Timer"), "timeout")

	currentDial = LOAD.dict._Dialogues[currentDial].next[1]
	time_delay = LOAD.dict._Dialogues[currentDial].time
	#AUTO SAVE
	dataDial = currentDial
	dataRep = null
	dataNextTime = OS.get_unix_time() + int(time_delay)
	system_save()
	LOAD.launch = 1
	print("Lancement du timer",time_delay," seconde(s)")

# BOUTON 2
func _on_Bouton2_pressed():
	get_node("vbox/Bot/VBoxBot/Bouton2/Sprite2").set_texture(load("res://img/bouton_clic.jpg"))
	print("Temporisation : ",time_delay," seconde(s)")
	timer.set_wait_time(0.1)
	timer.start()
	yield(get_node("Timer"), "timeout")
	print("Fin du timer")
	get_node("vbox/Bot/VBoxBot/Bouton2/Sprite2").set_texture(load("res://img/bouton_base.jpg"))
	clean()
	print("Bouton n°2 activé")

# AUTO SAVE
	print("Auto-Sauvegarde")
	dataDial = currentDial
	dataRep = 2
	dataNextTime = OS.get_unix_time() + int(time_delay)
	system_save()

# Ecrit une ligne de Dialogue
	print("Création du label")
	var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelRep")
	var label = labelbase.duplicate()
	print("Configuration du label")
	label.set_name(str("label",LOAD.dict._Dialogues[currentDial],2))
	get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
	label.show()
	print("Ecrit la ligne de dialogue : ",LOAD.dict._Dialogues[currentDial].content[2])
	label.set_text(str(LOAD.dict._Dialogues[currentDial].content[2]))

# Ajustement de la taille du label
	var labelsize = label.get_line_count()
	print(str("Nombre de ligne :",labelsize))
	if labelsize == 1:
		label.set_size(Vector2(925,55))
		label.set("rect/min_size",Vector2(925,55))
	elif labelsize == 2:
		label.set_size(Vector2(925,110))
		label.set("rect/min_size",Vector2(925,110))
	elif labelsize == 3:
		label.set_size(Vector2(925,165))
		label.set("rect/min_size",Vector2(925,165))
	print(str("Taille du label :",label.get_size()))

# Auto Scroll
	print("Scroll")
	yield(get_tree(), "idle_frame")
	get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
	vscroll = vscroll+label.get_size().height+20
	get_node("vbox/Mid/DialBox").set_v_scroll(vscroll)
# Affichage Smoothie
	print("Affichage")
	var visible = 0
	for i in range(9):
		label.set("visibility/self_opacity",visible)
		visible = visible + 0.10
		time_delay = 0.05
		timer.set_wait_time(time_delay)
		timer.start()
		yield(get_node("Timer"), "timeout")


	currentDial = LOAD.dict._Dialogues[currentDial].next[2]
	time_delay = LOAD.dict._Dialogues[currentDial].time
	#AUTO SAVE
	dataDial = currentDial
	dataRep = null
	dataNextTime = OS.get_unix_time() + int(time_delay)
	system_save()
	LOAD.launch = 1
	print("Lancement du timer",time_delay," seconde(s)")

# BOUTON 3
func _on_Bouton3_pressed():
	get_node("vbox/Bot/VBoxBot/Bouton3/Sprite3").set_texture(load("res://img/bouton_clic.jpg"))
	print("Temporisation : ",time_delay," seconde(s)")
	timer.set_wait_time(0.1)
	timer.start()
	yield(get_node("Timer"), "timeout")
	print("Fin du timer")
	get_node("vbox/Bot/VBoxBot/Bouton3/Sprite3").set_texture(load("res://img/bouton_base.jpg"))
	clean()
	print("Bouton n°3 activé")

# AUTO SAVE
	print("Auto-Sauvegarde")
	dataDial = currentDial
	dataRep = 3
	dataNextTime = OS.get_unix_time() + int(time_delay)
	system_save()

# Ecrit une ligne de Dialogue
	print("Création du label")
	var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelRep")
	var label = labelbase.duplicate()
	print("Configuration du label")
	label.set_name(str("label",LOAD.dict._Dialogues[currentDial],3))
	get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
	label.show()
	print("Ecrit la ligne de dialogue : ",LOAD.dict._Dialogues[currentDial].content[3])
	label.set_text(str(LOAD.dict._Dialogues[currentDial].content[3]))

# Ajustement de la taille du label
	var labelsize = label.get_line_count()
	print(str("Nombre de ligne :",labelsize))
	if labelsize == 1:
		label.set_size(Vector2(925,55))
		label.set("rect/min_size",Vector2(925,55))
	elif labelsize == 2:
		label.set_size(Vector2(925,110))
		label.set("rect/min_size",Vector2(925,110))
	elif labelsize == 3:
		label.set_size(Vector2(925,165))
		label.set("rect/min_size",Vector2(925,165))
	print(str("Taille du label :",label.get_size()))

# Auto Scroll
	print("Scroll")
	yield(get_tree(), "idle_frame")
	get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
	vscroll = vscroll+label.get_size().height+20
	get_node("vbox/Mid/DialBox").set_v_scroll(vscroll)
# Affichage Smoothie
	print("Affichage")
	var visible = 0
	for i in range(9):
		label.set("visibility/self_opacity",visible)
		visible = visible + 0.10
		time_delay = 0.05
		timer.set_wait_time(time_delay)
		timer.start()
		yield(get_node("Timer"), "timeout")

	currentDial = LOAD.dict._Dialogues[currentDial].next[3]
	time_delay = LOAD.dict._Dialogues[currentDial].time
	#AUTO SAVE
	dataDial = currentDial
	dataRep = null
	dataNextTime = OS.get_unix_time() + int(time_delay)
	system_save()
	LOAD.launch = 1
	print("Lancement du timer",time_delay," seconde(s)")

# Nettoyage des boutons inutiles
func clean():
	print("Suppression des boutons")
	for i in range(4):
		get_node(str("vbox/Bot/VBoxBot/Bouton",i)).set_text("")
		get_node(str("vbox/Bot/VBoxBot/Bouton",i)).set_ignore_mouse(true)
		get_node(str("vbox/Bot/VBoxBot/Bouton",i)).set("visibility/visible",false)


		## FONCTIONS DIVERSES ##
# Toutes les fonctions utiles
func status():
# Status de l'interlocuteur
	print("Status de l'interlocuteur")
	# En ligne
	if time_delay <= 30:
		get_node("vbox/Top/Etat").clear()
		get_node("vbox/Top/Etat").add_text("Status : en ligne")
	# Occupé
	elif time_delay > 30 and time_delay <= 180:
		get_node("vbox/Top/Etat").clear()
		get_node("vbox/Top/Etat").add_text("Status : occupé")
	# Absent
	elif time_delay > 180 and time_delay <= 300:
		get_node("vbox/Top/Etat").clear()
		get_node("vbox/Top/Etat").add_text("Status : absent")
	# Hors Ligne
	elif time_delay > 300:
		get_node("vbox/Top/Etat").clear()
		get_node("vbox/Top/Etat").add_text("Status : hors-ligne")
	return

# Reset de la sauvegarde
func _on_resetSave_pressed():
	get_tree().change_scene("res://scn/option.tscn")
	GLOBAL.backoption = "res://scn/base.tscn.xml"

# SYSTEME DE SAUVEGARDE
func system_save():
	print("Auto-Sauvegarde")
	saveDial.push_back(dataDial)
	saveRep.push_back(dataRep)
	saveNextTime.push_back(dataNextTime)
	print(saveDial)
	print(saveRep)
	print(saveNextTime)
	data = {"_Save" : {"dial" : saveDial,"rep" : saveRep, "nexttime" : saveNextTime}}
	var file = File.new()
	#file.open_encrypted_with_pass("user://savelogs.json", File.WRITE, "reg65er9g84zertg1zs9ert8g4")
	file.open("user://savelogs.json", File.WRITE)
	file.store_line(data.to_json())
	file.close()
	return

func system_time():
	# Récupération de l'heure du système
	var timeSys = OS.get_datetime_from_unix_time(saveTime)
	var hourSys = timeSys.hour
	var minuteSys = timeSys.minute
	var secondSys = timeSys.second

	if calcultime < 0:
		hourSys = hourSys - calcultime
	else:
		hourSys = hourSys + calcultime

	# Ajustement de l'heure
	if hourSys < 10:
		hourIG = str("0",hourSys)
	else:
		hourIG = hourSys
	if minuteSys < 10:
		minuteIG = str("0",minuteSys)
	else:
		minuteIG = minuteSys
	if secondSys < 10:
		secondIG = str("0",secondSys)
	else:
		secondIG = secondSys

	timeIG = str(hourIG,":",minuteIG,":",secondIG)
	return

func system_exit():
	var nextDial = LOAD.dial.next
	if LOAD.dict._Dialogues[currentDial].ref == 1 and LOAD.dict._Dialogues[nextDial].ref == 1:
		print("Auto-Sauvegarde")
		unixTime = OS.get_unix_time()
		time_delay = LOAD.dict._Dialogues[nextDial].time
		dataDial = nextDial
		dataRep = null
		dataNextTime = unixTime + int(time_delay)
		system_save()

func _notification(notification_signal):
	if notification_signal == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		system_exit()
