# Crédits #
# Script par LEIFER KOPF // leifer.kopf@gmail.com
# Scénario par NOOTILUS //
# Disclaimer : L'ensemble du contenu de ce document est la propriété de GalaaDScript, il ne peut être utilisé, même partiellement sans accord préalable de GalaaDScript (Filliale du groupe AE-Com).
# version : 0.21

extends Control

var dict = {}
var currentDial = "dial001"


# Ouverture du fichier JSON du scénario
func _ready():
	print("ready")
	start()
	
func start():
	print("start")
	
	var file = File.new()
	file.open("res://json/credit.json", file.READ)
	dict.parse_json(file.get_as_text())
	file.close()
		
	while currentDial in dict._Dialogues and dict._Dialogues[currentDial].ref == 1 :
		print(str("[",currentDial,"] : ",dict._Dialogues[currentDial].content,"\n"))
		get_node("Dialogues").push_align(0)
		get_node("Dialogues").add_text(str("\n [",currentDial,"] : ",dict._Dialogues[currentDial].content))
		currentDial = dict._Dialogues[currentDial].next
	
	# Ecriture des réponses
	print(str("Content [",currentDial,"] : ",dict._Dialogues[currentDial].content))
	print(dict._Dialogues[currentDial].content.size())
		
	for i in range(dict._Dialogues[currentDial].content.size()):
		get_node(str("Bouton",i)).set_text(str("[",currentDial,"] : ",dict._Dialogues[currentDial].content[i]))
		get_node(str("Bouton",i)).set_ignore_mouse(false)
		get_node(str("Bouton",i)).set_flat(false)

func _on_Bouton0_pressed():
	print("Bouton 0")
	print(dict._Dialogues[currentDial].next[0])
	get_node("Dialogues").push_align(2)
	get_node("Dialogues").add_text(str("\n[",currentDial,"] : ",dict._Dialogues[currentDial].content[0]))
	currentDial = dict._Dialogues[currentDial].next[0]
	print(currentDial)
	clean()
	start()
		
func _on_Bouton1_pressed():
	print("Bouton 1")
	print(dict._Dialogues[currentDial].next[1])
	get_node("Dialogues").push_align(2)
	get_node("Dialogues").add_text(str("\n[",currentDial,"] : ",dict._Dialogues[currentDial].content[1]))
	currentDial = dict._Dialogues[currentDial].next[1]
	print(currentDial)
	clean()
	start()
		
func _on_Bouton2_pressed():
	print("Bouton 2")
	print(dict._Dialogues[currentDial].next[2])
	get_node("Dialogues").push_align(2)
	get_node("Dialogues").add_text(str("\n [",currentDial,"] : ",dict._Dialogues[currentDial].content[2]))
	currentDial = dict._Dialogues[currentDial].next[2]
	print(currentDial)
	clean()
	start()
		
func _on_Bouton3_pressed():
	print("Bouton 3")
	print(dict._Dialogues[currentDial].next[3])
	get_node("Dialogues").push_align(2)
	get_node("Dialogues").add_text(str("\n [",currentDial,"] : ",dict._Dialogues[currentDial].content[3]))
	currentDial = dict._Dialogues[currentDial].next[3]
	print(currentDial)
	clean()
	start()
	

func clean():
	for i in range(3):
		get_node(str("Bouton",i)).set_text("")
		get_node(str("Bouton",i)).set_ignore_mouse(true)
		get_node(str("Bouton",i)).set_flat(true)


