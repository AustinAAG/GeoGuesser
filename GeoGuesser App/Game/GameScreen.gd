extends Panel

# Load in child nodes as variabels
onready var streetView = $MarginContainer/StreetView
onready var button1 = $Options/Panel/HBoxContainer/Button
onready var button2 = $Options/Panel/HBoxContainer/Button2
onready var button3 = $Options/Panel/HBoxContainer/Button3
onready var button4 = $Options/Panel/HBoxContainer/Button4
onready var timer = $Countdown/Timer
onready var streetViewContainer = $MarginContainer

#image variables
var width
var height
var image

# HTTP Request parsing
var http_request1
var http_request2
var data : PoolStringArray

# Street View Variables
var image_url = "https://maps.googleapis.com/maps/api/streetview?size="
var new_url
var latitude
var longitude
export var st_view_width = "600"
export var st_view_height = "300"
export var heading = "0"
export var fov = "90"
export var pitch = "0"
export var radius = "1000"

var rng = RandomNumberGenerator.new()

# Street View Metadata Variables
var metadata_url = "https://maps.googleapis.com/maps/api/streetview/metadata?"
var location_url
var location_found = false

# Constants
var API_KEY = ""

func _ready():
	randomize()
	# Create an HTTP request node and connect its completion signal.
	http_request1 = HTTPRequest.new()
	add_child(http_request1)
	http_request1.connect("request_completed", self, "_http_request_completed1")
	
	http_request2 = HTTPRequest.new()
	add_child(http_request2)
	http_request2.connect("request_completed", self, "_http_request_completed2")
	
	new_location()

func _physics_process(delta):
	if width != streetViewContainer.get_size().x || height != streetViewContainer.get_size().y:
		width = streetViewContainer.get_size().x
		height = streetViewContainer.get_size().y
		if image != null:
			image.resize(width, height, 1)
			var texture = ImageTexture.new()
			texture.create_from_image(image)
			streetView.texture = texture


func http_request1(url):
	# Perform the HTTP request. The URL below returns a PNG and JPG image as of writing.
	var error = http_request1.request(url)
	if error != OK:
		push_error("an error occured in the HTTP request.")


func _http_request_completed1(result, response_code, headers, body):
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

func http_request2(url):
	# Perform the HTTP request. The URL below returns a PNG and JPG image as of writing.
	var error = http_request2.request(url)
	if error != OK:
		push_error("an error occured in the HTTP request.")

func _http_request_completed2(result, response_code, headers, body):
	var response = body.get_string_from_utf8()
	print("looking for location")
	if "OK" in response:
		print("location found")
		st_view_width = str(streetViewContainer.get_size().x)
		st_view_height = str(streetViewContainer.get_size().y)
		new_url = image_url + st_view_width + "x" + st_view_height + "&location=" + latitude + "," + longitude + "&heading=" + heading + "&pitch=" + pitch + "&fov=" + fov + "&radius=" + radius + "&key=" + API_KEY
		http_request1(new_url)
	else:
		print("looking for new location")
		new_location()

func new_location():
	latitude = str(rng.randf_range(0.000000, 1.0)*180 - 90)
	longitude = str(rng.randf_range(0.000000, 1.0)*360 - 180)
	location_url = metadata_url + "&location=" + latitude + "," + longitude + "&heading=" + heading + "&pitch=" + pitch + "&fov=" + fov + "&radius=" + radius + "&key=" + API_KEY
	http_request2(location_url)


func _on_Button4_pressed():
	pass # Replace with function body.


func _on_Button3_pressed():
	pass # Replace with function body.


func _on_Button2_pressed():
	pass # Replace with function body.


func _on_Button_pressed():
	pass # Replace with function body.


func _on_Countdown_timer_ended():
	new_location()
	http_request1(new_url)
