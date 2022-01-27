extends Control

# $DisplayText == get_node("DisplayText")

var player_words : Array
var current_story : Dictionary
onready var PlayerText : LineEdit = $VBoxContainer/HBoxContainer/PlayerText
onready var DisplayText : Label = $VBoxContainer/DisplayText


func _ready ():
	set_current_story_from_json()
	DisplayText.text = "  <kastor.code/>  \n\nWelcome to Loony Lips! We're going to tell a story and have a wonderful time!\n\n"
	check_player_words_length()
	PlayerText.grab_focus()


func _on_PlayerText_text_entered (new_text):
	add_to_player_words()


func _on_TextureButton_pressed ():
	if (is_story_done()):
		get_tree().reload_current_scene()
	else:
		add_to_player_words()


func set_current_story ():
	randomize()
	var stories = $StoryBook.get_child_count()
	var selected_story = randi() % stories
	current_story.prompts = $StoryBook.get_child(selected_story).prompts
	current_story.story = $StoryBook.get_child(selected_story).story


func set_current_story_from_json ():
	randomize()
	var stories = get_from_json("StoryBook.json")
	current_story = stories[randi() % stories.size()]


func get_from_json (filename):
	var file = File.new()
	file.open(filename, File.READ)
	var text = file.get_as_text()
	var data = parse_json(text)
	file.close()
	return data


func add_to_player_words ():
	player_words.append(PlayerText.text)
	DisplayText.text = ""
	PlayerText.clear()
	check_player_words_length()


func is_story_done ():
	return player_words.size() == current_story.prompts.size()


func check_player_words_length ():
	if (is_story_done()):
		end_game()
	else:
		prompt_player()


func tell_story ():
	DisplayText.text = current_story.story % player_words


func prompt_player ():
	DisplayText.text += "May I have " + current_story.prompts[player_words.size()] + " please?"


func end_game ():
	PlayerText.queue_free()
	$VBoxContainer/HBoxContainer/Label.text = "Again"
	tell_story()
