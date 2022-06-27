extends Panel

onready var streetView = $StreetView
onready var button1 = $Options/Panel/HBoxContainer/Button
onready var button2 = $Options/Panel/HBoxContainer/Button2
onready var button3 = $Options/Panel/HBoxContainer/Button3
onready var button4 = $Options/Panel/HBoxContainer/Button4
onready var timer = $Countdown/Timer

var data : PoolStringArray
var original_url = "https://www.generatormix.com/random-image-generator"
var img_url_passed
var http_request
var new_image_url

func _ready():
	# Create an HTTP request node and connect its completion signal.
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")
	
	http_request(original_url)


func http_request(url):
	if url == original_url:
		img_url_passed = false
	else:
		img_url_passed = true
	
	print(url)
	# Perform the HTTP request. The URL below returns a PNG and JPG image as of writing.
	var error = http_request.request(url)
	if error != OK:
		push_error("an error occured in the HTTP request.") 


func _http_request_completed(result, response_code, headers, body):
	if !img_url_passed:
		var response = body.get_string_from_utf8()
		data = response.split('<img class="lazy thumbnail" src="')
		var image_url = str(data[1]).split('" data-src=')
		new_image_url = image_url[1].split("\"")
		print(new_image_url[1])
		#http_request(str(image_url[1]))
		http_request(str(new_image_url[1]))
		#print(image_url[0])
		#print("----------")
		#print(image_url)
	
	var image = Image.new()
	
	if '.jpg' in new_image_url[1]:
		var error = image.load_jpg_from_buffer(body)
		if error != OK:
			push_error("Couldn't load the image.")

	if '.png' in new_image_url[1]:
		var error = image.load_png_from_buffer(body)
		if error != OK:
			push_error("Couldn't load the image.")
	
	
	image.resize(streetView.get_size().x, streetView.get_size().y, 1)
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
