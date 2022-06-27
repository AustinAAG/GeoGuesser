extends Panel

onready var streetView = $MarginContainer/StreetView
onready var button1 = $Options/Panel/HBoxContainer/Button
onready var button2 = $Options/Panel/HBoxContainer/Button2
onready var button3 = $Options/Panel/HBoxContainer/Button3
onready var button4 = $Options/Panel/HBoxContainer/Button4
onready var timer = $Countdown/Timer
onready var streetViewContainer = $MarginContainer

var data : PoolStringArray
var original_url = "https://maps.googleapis.com/maps/api/streetview?size=600x300&location=40.170141,-76.994244&heading=151.78&pitch=-0.76&key="
var img_url_passed
var http_request
var new_image_url
var width
var height
var image

func _ready():
	# Create an HTTP request node and connect its completion signal.
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")
	
	http_request(original_url)

func _physics_process(delta):
	print(streetViewContainer.get_size().x)
	print(streetViewContainer.get_size().y)
	if width != streetViewContainer.get_size().x || height != streetViewContainer.get_size().y:
		width = streetViewContainer.get_size().x
		height = streetViewContainer.get_size().y
		if image != null:
			image.resize(width, height, 1)
			var texture = ImageTexture.new()
			texture.create_from_image(image)
			streetView.texture = texture


func http_request(url):
	# Perform the HTTP request. The URL below returns a PNG and JPG image as of writing.
	var error = http_request.request(url)
	if error != OK:
		push_error("an error occured in the HTTP request.") 


func _http_request_completed(result, response_code, headers, body):
	image = Image.new()
	var error = image.load_jpg_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")
	
	image.resize(width, height, 1)
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	#Display the image in a TextureRect node.
	streetView.texture = texture
	timer.start()


func _on_Button4_pressed():
	pass # Replace with function body.


func _on_Button3_pressed():
	pass # Replace with function body.


func _on_Button2_pressed():
	pass # Replace with function body.


func _on_Button_pressed():
	pass # Replace with function body.


func _on_Countdown_timer_ended():
	http_request(original_url)
